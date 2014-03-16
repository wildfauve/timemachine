class Employee
  
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :name, :type => String
  field :billable_u, :type => Float
  field :summ_refresh_date, :type => Time
  
  validates_uniqueness_of :name
  
  has_and_belongs_to_many :projects
  embeds_many :projectstates
  embeds_many :days
  has_many :projsummaries
  belongs_to :user

  def self.create_it(params)
    emp = self.new(params)
    emp.save
    emp
  end
  
  def self.has_project_time?(project)
    self.where('days.entries.project' => project.id).count > 0 ? true : false
  end
  
  def self.delete_project(project)
    self.where(:project_ids => project).each {|emp| emp.projects.delete(project)}
  end
  
  def update_it(params)
    self.attributes = (params[:employee])
    if params[:project].present?
      proj = Project.find(params[:project])
      self.projects << proj
    end
    save
  end
  
  def add_time(params)
    # check if day already found
    day_find = self.days.where(:date => params[:date])
    if day_find.count > 0
      day = day_find.first.add_time(params)
    else
      day = Day.new
      self.days << day.add_time(params)[:day]
    end
    #projsum = self.projsummaries.find_or_create_by(:name)
    save
  end

  def all_days
    self.days.collect {|d| d.date}.sort {|x,y| x <=> y}
  end
  
  def total_number_days
    tot = self.all_days
    Utilities.working_days_between(tot[0], tot[-1]).to_f
  end

  def project_entry_for_day(day: nil, project: nil)
    # TODO: This will probably break for Time Entry as I'm using project_id and date string
    project = Project.find(project) if project.class != Project
    day = Date.parse(day) if day.class != Date
    return @day_entry if @day_entry && @day_entry.project == project.id && @day_find.date == day
    day_find = self.days.where(:date => day)
    if day_find.count == 0
      nil
    else
      @day_find = day_find.first
      @day_entry = @day_find.entry(project)
    end    
  end

  
  def project_hours_by_day(params)
    day_find = self.days.where(:date => params[:date])
    if day_find.count == 0
      0
    else
      day_find.first.project_hours(params[:project_id])
    end    
  end

  def total_hours_by_day(params)
    day_find = self.days.where(:date => params[:date])
    if day_find.count == 0
      0
    else
      day_find.first.total_hours
    end
  end
  
  def cost_code_entry_by_day(day: nil, project: nil, code: nil)
    pe = project_entry_for_day(day: day, project: project)
    return nil if pe.nil?
    pe.cost_code(code).try(:hours)
  end
  
  def billable_calc
    self.projsummaries.select {|ps| ps.assigned_project.billable}.inject(0.to_f) {|n, v| n += v.total_hours}
  end
  
  def erase_time
    self.days = nil
    save
  end
  
  def mod_project_state(params)
    ps = self.projectstates.find_or_create_by(:project => params[:project])
    ps.mod(params)
    self.save!
    self
  end
  
  def project_viewable(proj)
    ps = self.projectstates.where(:project => proj.id)
    ps.count > 0 ? ps.first.viewable : true
  end
  
  def viewable_projects
    self.projects.select {|p| self.project_viewable(p)}.sort {|x, y| x.customer.name <=> y.customer.name }
  end
  
  def viewable_customer_projects(customer)
    self.viewable_projects.select {|vp| vp.customer == customer}
  end
  
  def customers
    self.viewable_projects.collect {|vp| vp.customer}.uniq!
  end
    
  def refresh_totals
    # Only deals with 1 employee summary
    Dashboard.new(:employee => self).calc_summary.summ_by_project.each do |proj|
      self.projsummaries << Projsummary.store(proj)
    end
      self.billable_u = (self.billable_calc / (self.total_number_days * 8)) * 100
      self.summ_refresh_date = Time.now
      save
  end
    

end