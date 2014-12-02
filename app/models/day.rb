class Day
  
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :date, :type => Date
  belongs_to :employee
  embeds_many :entries

  def project_hours(project_id)
    project = Project.find(project_id)
    ent = self.entries.where(:project => project.id)
    ent.count == 0 ? 0 : ent.first.hours
  end

  def total_hours
    entries.inject(0) {|t, e| t += e.hours}
  end

  def entry(project)
    e = self.entries.where(project: project.id)
    e.count > 0 ? e.first : nil 
  end

  def add_time(params)
    self.date = params[:date]
    ass_entry = self.entries.where(:project => params[:project].id).first
    if ass_entry
      ass_entry.add_time(params)
    else
      ass_entry = Entry.new
      self.entries << ass_entry.add_time(params)
    end
    return {:entry => ass_entry, :day => self}
  end
  
#  def assigned_project
#    return Project.find(project)
#  end
  

end