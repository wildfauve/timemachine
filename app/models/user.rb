class User
  
  attr_accessor :password
  
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :name, :type => String 
  field :password_hash, type: String 
  field :password_salt, type: String
  
  before_save :encryot
  
  def encrypt
    if password.present?
      self.password_salt = BCrypt::Engine.generate_salt
      self.password_hash = BCrypt::Engine.hash_secret(password, password_salt)      
    end
  end

end