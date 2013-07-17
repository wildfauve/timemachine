class Day
  
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :name, :type => String
  embedded_by :employee, :inverse_of => :days
  embeds :assignment_days

end