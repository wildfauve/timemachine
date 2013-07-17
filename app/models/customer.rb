class Customer
  
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :name, :type => String
  
  validates_uniqueness_of :name
  
  has_many :projects
  
  def self.create_it(params)
    cus = self.new(params)
    cus.save
    cus
  end
  
  def self.create_project(params)
    cus = self.find(params[:customer_id])
    cus.projects << Project.create_it(params[:project])
    cus.save
  end
    

end