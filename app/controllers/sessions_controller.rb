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
    @user = User.create_it(params)
    respond_to do |format|
      if @user.valid?
        format.html { redirect_to root_url, notice: "Signed Up" }
        format.json
      else
        format.html { render action: "new" }
        format.json
      end
    end
    
  end
  
end