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
  end
  
  def edit
  end
  
  def update
  end
  
  
end