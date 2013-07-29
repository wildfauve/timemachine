class ProjectsController < ApplicationController
  
  def index
    @projects = Project.all
  end
  
  def new
    @customer = Customer.find(params[:customer_id])
    @project = Project.new
  end
  
  def create
    @customer = Customer.find(params[:customer_id]).create_project(params[:project])
    respond_to do |format|
      if @customer.valid?
        format.html {redirect_to customers_path}
      else
        raise
      end
    end    
  end
  
  def show
  end
  
  def edit
    @customer = Customer.find(params[:customer_id])
    @project = Project.find(params[:id])
    respond_to do |format|
      format.js {render 'edit_project_form', :layout => false }
    end
  end
  
  def update
    @customer = Customer.find(params[:customer_id]).update_project(params)
    respond_to do |format|
      if @customer.valid?
        format.html {redirect_to customers_path}
      else
        raise
      end
    end    
    
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