class Costcodeentry
  
  include Mongoid::Document
  include Mongoid::Timestamps  

  field :costcode, :type => Moped::BSON::ObjectId
  field :hours, :type => Float
  embedded_in :entry, :inverse_of => :costcodeentries
  
  def self.create_it(params)
    Costcodeentry.new(params)
  end
  
end
