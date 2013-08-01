class Projsummary
  
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :total_hours, :type => Float
  field :start_date, :type => Date
  field :end_date, :type => Date
  
  field :project, :type => Moped::BSON::ObjectId
  belongs_to :employee, :inverse_of => :projsummaries

  def self.store(proj)
    project = self.find_or_create_by(:project => proj[:project].id)
    project.summ(proj[:dates])
    return project
  end
  
  def summ(dates)
    d = dates.select {|k,v| v > 0}.keys
    self.start_date = d.min
    self.end_date = d.max
    self.total_hours = dates.inject(0) {|c, (k,v)| c += v}
  end
  
  def assigned_project
    Project.find(self.project)
  end
  
  def total_utilisation
    if self.start_date
      (self.total_hours / 8) / (self.end_date.mjd - self.start_date.mjd + 1) * 100
    else
      0
    end
  end
  
  def avg_effort
    if self.start_date
      dur = self.end_date.mjd - self.start_date.mjd
      dur > 7 ? self.total_hours / (dur.to_f / 7) : self.total_hours
    else
      0
    end
  end
  
end