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
  
  def self.create_project(params)
    cus = self.find(params[:customer_id])
    cus.projects << Project.create_it(params[:project])
    cus.save!
  end
    
  def self.all_projects
    projects = []
    all = self.all.each {|cust| cust.projects.each {|proj| projects << proj }}
    return projects
  end
  
  def remove_project(project)
    if Employee.has_project_time?(project)
      errors.add(:project, "Can't delete project when time is allocated")
    else  
      self.projects.delete(project)
#      Employee.delete_project(project)
    end
  end

end