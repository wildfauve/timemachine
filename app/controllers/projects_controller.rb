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
  
  
end