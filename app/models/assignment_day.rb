class Day
  
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :name, :type => String
  embedded_by :day, :inverse_of => :assignment_days

end