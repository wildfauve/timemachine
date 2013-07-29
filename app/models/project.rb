class Project
  
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :name, :type => String
  field :desc, :type => String
  
  validates_uniqueness_of :name
  
  belongs_to :customer

  has_and_belongs_to_many :employees
  
  def self.create_it(params)
    proj = Project.new(params)
    proj
  end
  
  def update_it(params)
    self.attributes = params
    save!
  end
  
  def hyphenise_name
    self.name.gsub(/ /, '-')
  end
  
end