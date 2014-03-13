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
    @customer = Customer.find(params[:customer_id])
    respond_to do |format|
      if @project.valid?
        format.js { render 'modal_close', layout: false }
      else
        raise
      end
    end        
  end
  
  def show
  end
  
  def edit
    @customer = Customer.find(params[:customer_id])
    @project = Project.find(params[:project_id])
    @costcode = @project.costcodes.find(params[:id])
    respond_to do |format|
      format.js {render 'modal_code_form', layout: false }
    end    
  end
  
  def update
    @project = Project.find(params[:project_id]).update_costcode(params)
    @customer = Customer.find(params[:customer_id])    
    respond_to do |format|
      if @project.valid?
        format.js { render 'modal_close',  layout: false }
      else
        raise
      end
    end            
  end
  
  def destroy
    @project = Project.find(params[:project_id]).delete_costcode(params)
    @customer = Customer.find(params[:customer_id])
    respond_to do |format|
      if @project.valid?
        format.html { redirect_to edit_customer_path(@customer) }
      else
        raise
      end
    end
  end
  
  
end