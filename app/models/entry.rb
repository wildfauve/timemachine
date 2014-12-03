class Entry
  
  attr_accessor :diff
  
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :hours, :type => Float
  field :project, :type => BSON::ObjectId
  field :note, type: String
  embedded_in :day, :inverse_of => :entries
  embeds_many :costcodeentries

  def add_time(hour: nil, proj: nil, date: nil, custom_num: nil, fill_value: nil, note: nil, cost_codes: nil)
    self.project = proj.id
    self.note = note if note.present?
    if cost_codes.present?
      raise
      self.cost_codes = cost_codes
    end
    if hour.present?
      self.hours ? @diff = hour.to_f - self.hours : @diff = hour.to_f
      self.hours = hour
    elsif custom_num.present?
      self.hours ? @diff = custom_num.to_f - self.hours : @diff = custom_num.to_f
      self.hours = custom_num
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
      ce = self.costcodeentries.where(costcode: in_code).first
      if ce
        ce.code_hours = value
      else
        self.costcodeentries << Costcodeentry.create_it(costcode: in_code, hours: value)
      end
    end 
  end
  
  def cost_code(code)
    self.costcodeentries.where(costcode: code).try(:first)
  end

end