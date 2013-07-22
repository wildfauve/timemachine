class AssignmentsController < ApplicationController
  
  def index
  end
  
  def new
    @employee = Employee.find(params[:employee_id])
    @project = Project.find(params[:project_id])
    @date = Date.today
    respond_to do |format|
      format.js {render 'time_form', :layout => false }
    end
  end
  
end