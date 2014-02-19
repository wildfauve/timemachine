class Entry
  
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :hours, :type => Float
  field :project, :type => Moped::BSON::ObjectId
  field :note, type: String
  embedded_in :day, :inverse_of => :entries

  def add_time(params)
    self.project = params[:project].id
    self.note = params[:note] if params[:note].present?
    if params[:hour].present?
      self.hours = params[:hour]
    elsif params[:custom_num].present?
      self.hours = params[:custom_num]
    else
      raise
    end
    return self
  end
  
  def assigned_project
    return Project.find(project)
  end

end