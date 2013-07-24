class ProjectsController < ApplicationController
  
  def index
    @projects = Project.all
  end
  
  def new
    @customer = Customer.find(params[:customer_id])
    @project = Project.new
  end
  
  def create
    @customer = Customer.create_project(params)
  end
  
  def show
  end
  
  def edit
  end
  
  def update
  end
  
  def destroy
    @customer = Customer.find(params[:customer_id])
    @project = Project.find(params[:id])
    @customer.remove_project(@project)
    Rails.logger.info(">>>Project Controller>> #{@customer.errors.inspect}  #{@customer.errors.any?}")        
    respond_to do |format|
      format.js {render 'remove_proj', :layout => false }
    end      
    
  end
  
  
end