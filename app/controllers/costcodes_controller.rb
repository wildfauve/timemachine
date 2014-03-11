class CostcodesController < ApplicationController
  
  def index

  end
  
  def new
    @customer = Customer.find(params[:customer_id])
    @project = Project.find(params[:project_id])
    @costcode = Costcode.new
    respond_to do |format|
      format.js {render 'modal_code_form', layout: false }
    end    
  end
  
  def create
    @project = Project.find(params[:project_id]).create_costcode(params[:costcode])
    respond_to do |format|
      if @project.valid?
        format.js { render layout: false }
      else
        raise
      end
    end        
  end
  
  def show
  end
  
  def edit
  end
  
  def update
  end
  
  def destroy
  end
  
  
end