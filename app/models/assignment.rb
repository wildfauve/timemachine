class Assignment

  attr_accessor :project
  
  def self.load_project(project_id)
    return self.new(Project.find(project_id))
  end
  
  def initialize(proj)
    @project = proj
  end

end