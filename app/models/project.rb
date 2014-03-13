class Project
  
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :name, :type => String
  field :desc, :type => String
  field :billable, :type => Boolean
  
  validates_uniqueness_of :name
  
  belongs_to :customer
  
  embeds_many :costcodes

  has_and_belongs_to_many :employees
  
  def self.create_it(params)
    proj = Project.new(params)
    proj
  end
  
  def update_it(params)
    self.attributes = params
    save!
  end
  
  def create_costcode(params)
    self.costcodes << Costcode.create_it(params)
    save!
    self
  end
  
  def update_costcode(params)
    self.costcodes.find(params[:id]).update_it(params[:costcode])
    save!
    self
  end
  
  def delete_costcode(params)
    self.costcodes.find(params[:id]).destroy
    save!
    self
  end
  
  
  def hyphenise_name
    self.name.gsub(/ /, '-')
  end
  
  def is_billable?
    billable
  end
  
end