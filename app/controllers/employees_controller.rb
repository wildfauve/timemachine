class EmployeesController < ApplicationController
  
  def index
    @employees = Employee.all
    respond_to do |format|
      format.html
      format.json
    end
  end
  
  def new
    @employee = Employee.new
  end
  
  def create
    @employee = Employee.create_it(params[:employee])
    respond_to do |format|
      if @employee.valid?
        format.html { redirect_to employees_path }
        format.json
      else
        format.html { render action: "new" }
        format.json
      end
    end      
  end
  
  def show
    @employee = Employee.find(params[:id]) if !@employee
  end
  
  def edit
    @employee = Employee.find(params[:id]) if !@employee    
  end
  
  def update
    @employee = Employee.find(params[:id])    
    @employee.update_it(params)
    respond_to do |format|
      if @employee.valid?
        format.html { redirect_to employees_path }
        format.json
      else
        format.html { render action: "edit" }
        format.json
      end
    end      
    
  end
    
  def erase
    @employee = Employee.find(params[:id])
    @employee.erase_time
    respond_to do |format|
      format.html { redirect_to employees_path }
      format.json
    end
    
  end
  
  
  # PUT
  def projsummary
    @employee = Employee.find(params[:id])
    @employee.mod_project_summary(params)
    respond_to do |format|
      if @employee.valid?
        format.js { render layout: false }
      else
        raise
      end
    end    
  end
  
  # GET
  def project
    @employee = Employee.find(params[:id])
    @project = Project.find(params[:project])
    @projsummary = @employee.projsummaries.where(project: params[:project]).first
    respond_to do |format|
      format.js {render 'modal_project_form', :layout => false }
    end
    
  end

  def assignments
  end
  
end