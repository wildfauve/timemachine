class Costcode
  
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :code, type: String
  field :name, :type => String
  

  embedded_in :project
  
  def self.create_it(params)
    cc = self.new(params)
    cc
  end
  
  def update_it(params)
    self.attributes = params
    save!
  end
  
  def hyphenise_name
    self.name.gsub(/ /, '-')
  end
  
  def is_billable?
    billable
  end
  
end