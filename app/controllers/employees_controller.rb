class EmployeesController < ApplicationController
  
  def index
    @employees = Employee.all
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
    @employee = Employee.find(params[:id])
  end
  
  def edit
    @employee = Employee.find(params[:id])
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
  
  def calc
    raise
  end
  
  
end