class DaysController < ApplicationController
  
  def index
  end
  
  def new
    @employee = Employee.find(params[:employee_id])
    @assignment = Assignment.load_project(params[:assignment_id])
    @day = Day.new
    respond_to do |format|
      format.js {render 'time_form', :layout => false }
    end
  end
  
end