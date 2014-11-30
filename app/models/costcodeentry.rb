class Costcodeentry
  
  include Mongoid::Document
  include Mongoid::Timestamps  

  field :costcode, :type => BSON::Objectid
  field :hours, :type => Float
  embedded_in :entry, :inverse_of => :costcodeentries
  
  def self.create_it(params)
    Costcodeentry.new(params)
  end
  
  def code_hours=(hours)
    self.hours = hours
  end
    
  def related_costcode
    Costcode.find(costcode)
  end
end
