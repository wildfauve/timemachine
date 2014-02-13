class User
  
#  attr_accessible :name, :password
  
  attr_accessor :password
  
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :name, :type => String 
  field :role, :type => String
  field :password_hash, type: String 
  field :password_salt, type: String
  
  has_one :employee
  
  before_save :encrypt
  
  def self.create_it(params)
    user = self.new(params[:user])
    if params[:employee].present?
      emp = Employee.find(params[:employee])
      self.employee = emp
    end        
    user.save
    user
  end
  
  def self.authenticate(name, password)
    user = self.where(name: name).first
    if user && user.password_hash == BCrypt::Engine.hash_secret(password, user.password_salt)
      user
    else
      nil
    end
  end

  def update_it(params)
    self.attributes = (params[:user])
    if params[:employee].present?
      emp = Employee.find(params[:employee])
      self.employee = emp
    end    
    save
  end
  
  def encrypt
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)      
    end
  end
  
  def admin?
    self.role == 'admin'
  end

end