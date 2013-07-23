class AssignmentsController < ApplicationController
  
  def index
  end
  
  def new
    @employee = Employee.find(params[:employee_id])
    @project = Project.find(params[:project_id])
    @date = Date.today
    @assigment_day_proj = @employee.project_hours_by_day(:date => @date, :project_id => @project)
    respond_to do |format|
      format.js {render 'time_form', :layout => false }
    end
  end
  
  def date
    @employee = Employee.find(params[:employee_id])
    @project = Project.find(params[:id])
    @date = Date.parse(params[:date_opt])
    respond_to do |format|
      format.js {render 'time_form', :layout => false }
    end
    
  end
  
  
end