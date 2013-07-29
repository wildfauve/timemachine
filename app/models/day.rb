class Day
  
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :date, :type => Date
  embedded_in :employee, :inverse_of => :days
  embeds_many :entries

  def project_hours(project_id)
    project = Project.find(project_id)
    ent = self.entries.where(:project => project.id)
    ent.count == 0 ? 0 : ent.first.hours
  end

  def total_hours
    entries.inject(0) {|t, e| t += e.hours}
  end

  def add_time(params)
    self.date = params[:date]
    ass_find = self.entries.where(:project => params[:project].id)
    if ass_find.count > 0 
      ass_day = ass_find.first.add_time(params)
    else
      ass_day = Entry.new
      self.entries << ass_day.add_time(params)
    end
    self
  end
  
  def assigned_project
    return Project.find(project)
  end
  

end