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

  def add_time(hour: nil, proj: nil, date: nil, custom_num: nil, fill_value: nil, note: nil, cost_codes: nil)
    self.date = date
    ass_entry = self.entries.where(:project => proj.id).first
    if ass_entry
      ass_entry.add_time(hour: hour, proj: proj, date: date, custom_num: custom_num, fill_value: fill_value, note: note, cost_codes: cost_codes)
    else
      ass_entry = Entry.new
      self.entries << ass_entry.add_time(hour: hour, proj: proj, date: date, custom_num: custom_num, fill_value: fill_value, note: note, cost_codes: cost_codes)
    end
    return {:entry => ass_entry, :day => self}
  end
  
#  def assigned_project
#    return Project.find(project)
#  end
  

end