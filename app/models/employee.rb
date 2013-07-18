class Employee
  
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :name, :type => String
  
  validates_uniqueness_of :name
  
  has_and_belongs_to_many :projects
  embeds_many :days

  def self.create_it(params)
    emp = self.new(params)
    emp.save
    emp
  end

end