class Employee
  
  attr_accessor :claim
  
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :name, :type => String
  field :billable_u, :type => Float
  field :summ_refresh_date, :type => Time
  
  validates_uniqueness_of :name
  
  has_and_belongs_to_many :projects
#  embeds_many :projectstates
  embeds_many :days
  has_many :projsummaries
  has_many :claims
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
      self.projects << proj unless self.projects.include? proj
    end
    save
  end
  
  def add_time(params)
    # check if day already found
    day = self.days.where(:date => params[:date]).first
    if day
      day.add_time(params)
    else
      day = Day.new
      self.days << day.add_time(params)[:day]
    end
    #projsum = self.projsummaries.find_or_create_by(:name)
    save
  end

  # Expenses Management

  def create_expense(params)
    self.claims << Claim.add_expense(params)
    self
  end

  def update_expense(params)
    self.claims.find(params[:claim]).update_expense(params)
    self
    
#    Expense.find(params[:id]).update_it(params[:expense])
#    self
  end
  
  def set_expense_entered(params)
    @claim = self.claims.find(params[:claim])
    @claim.set_expense_entered(params)
    self
  end

  def delete_expense(params)
    claim = Claim.find(params[:claim])
    expense = claim.expenses.find(params[:id])
    expense.delete
    self
  end


  def set_claim_state_change(claim_id: nil, state: nil)
    self.claims.find(claim_id).set_claim_state_change(state: state)
  end


  # Utility Helpers

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
      return @day_entry = @day_find.entry(project)
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
  
  def cost_codes_by_project_by_day(project: nil, day: nil)
    pe = project_entry_for_day(day: day, project: project)
    if pe.try(:costcodeentries) && !pe.costcodeentries.empty?
      pe.costcodeentries.collect {|c| {project: project, costcodeentry: c}}
    end
  end
    
  def billable_calc
    self.projsummaries.select {|ps| ps.assigned_project.billable}.inject(0.to_f) {|n, v| n += v.total_hours}
  end
  
  def erase_time
    self.days = nil
    save
  end
  
  def mod_project_summary(params)
    ps = self.projsummaries.find_or_create_by(:project => params[:project])
    ps.mod(params)
    self.save!
    self
  end
  
  def project_viewable(proj)
    ps = self.projsummaries.where(:project => proj.id)
    ps.count > 0 ? ps.first.viewable : true
  end
  
  def viewable_projects
    self.projects.select {|p| self.project_viewable(p)}.sort {|x, y| x.customer.name <=> y.customer.name }
  end
  
  def viewable_customer_projects(customer)
    self.viewable_projects.select {|vp| vp.customer == customer}
  end

  def assigned_projects
    self.projects
  end
  
  def assigned_customers
    self.projects.collect {|ap| ap.customer}.uniq!
  end
  
  def project_summary(project)
    self.projsummaries.where(project: project.id).first
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