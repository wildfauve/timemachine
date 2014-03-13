class Entry
  
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :hours, :type => Float
  field :project, :type => Moped::BSON::ObjectId
  field :note, type: String
  embedded_in :day, :inverse_of => :entries
  embeds_many :costcodeentries

  def add_time(params)
    self.project = params[:project].id
    self.note = params[:note] if params[:note].present?
    if params[:costcodes].present?
      self.cost_codes = params[:costcodes]
    end
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
    Project.find(project)
  end
  
  def cost_codes=(codes)
    proj_codes = self.assigned_project.costcodes.collect {|c| c.id}
    codes.select {|n,v| !v.empty?}.each do |in_code, value|
      #self.assigned_project.costcodes.find(a.find {|c| c.to_s == v})
      
      #ce = self.code_entries.find_or_create_by(:)
      ce = self.costcodeentries.where(_id: in_code).first
      if ce
        raise
      else
        self.costcodeentries << Costcodeentry.create_it(costcode: in_code, value: value)
      end
    end
  end

end