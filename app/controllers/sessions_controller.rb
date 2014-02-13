class SessionsController < ApplicationController
  
  def index
  end
  
  def new 
    @user = User.new 
    respond_to do |format| 
      format.html 
    end 
  end
  
  def create
    user = User.authenticate(params[:name], params[:password])
    respond_to do |format|
      if user
        session[:user_id] = user.id
        if user.employee
          format.html { redirect_to employee_path(user.employee), notice: "Logged In" }
        else
          format.html { redirect_to admins_path, notice: "Logged In" }
        end
      else
        flash.now.alert = "Invalid Login"
        format.html { render action: "new" }
      end
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to root_url, notice: "Logged out"
  end
  
end