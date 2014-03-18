class ApplicationController < ActionController::Base
  protect_from_forgery
  
  helper_method :current_user
  
  before_filter :find_employee
  
  
  private
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  def find_employee
    @employee ||= current_user.employee if current_user && !current_user.admin?
  end 
    
end
