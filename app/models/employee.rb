class Employee
  
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :name, :type => String
  
  validates_uniqueness_of :name
  
  has_and_belongs_to_many :projects
  embeds_many :days
  has_many :projsummaries

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
  
  def set_date_range(state)
    if state
      if state == "timesheet"
        today = Date.today
        start_month = (today.change({:day => 1})..today.change({:day => 15}))
        end_month = (today.change({:day => 15})..today.end_of_month)
        today <= Date.today.change({:day => 15}) ? @date_range = start_month : @date_range = end_month
      end
    else
      @date_range = nil
    end
    self
  end
  
  def day_range
    c = self.days.select {|d| @date_range === d.date}.collect {|d| d.date}
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
  
  def erase_time
    self.days = nil
    save
  end
  
  def refresh_totals
    Dashboard.new(:employee => self).summary.each do |proj|
      self.projsummaries << Projsummary.store(proj)
      save
    end
  end
    

end