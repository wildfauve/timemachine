class Customer
  
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :name, :type => String
  
  validates_uniqueness_of :name
  
  has_many :projects, :dependent => :delete
  
  def self.create_it(params)
    cus = self.new(params)
    cus.save
    cus
  end
  

    
  def self.all_projects
    projects = []
    all = self.all.each {|cust| cust.projects.each {|proj| projects << proj }}
    return projects
  end

  def create_project(params)
    self.projects << Project.create_it(params)
    save!
    self
  end

  def update_project(params)
    Project.find(params[:id]).update_it(params[:project])
    self
  end

  
  def remove_project(project)
    if Employee.has_project_time?(project)
      errors.add(:project, "Can't delete project when time is allocated")
    else  
      Employee.delete_project(project)      
      self.projects.delete(project)
    end
  end

end