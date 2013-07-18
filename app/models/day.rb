class Day
  
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :name, :type => String
  embedded_in :employee, :inverse_of => :days
  embeds_many :assignment_days

end