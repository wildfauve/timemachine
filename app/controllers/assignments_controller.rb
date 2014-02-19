class AssignmentsController < ApplicationController
  
  def index
  end
  
  def new
    @employee = Employee.find(params[:employee_id])
    @project = Project.find(params[:project_id])
    @date = Date.today
    respond_to do |format|
      format.js {render 'time_form', :layout => false }
      format.html {render 'time_form'}
    end
  end
  
  def edit
    @employee = Employee.find(params[:employee_id])
    @project = Project.find(params[:project_id])
    @date = params[:day]
    respond_to do |format|
      format.js {render 'modal_time_form', :layout => false }
    end    
  end
  
  def update
    @employee = Employee.find(params[:employee_id])
    @project = Project.find(params[:id])
    @employee.add_time(params.merge({:project => @project}))
    @date = params[:date]    
    @entry = @employee.project_entry_for_day(day: @date, project: @project)    
    respond_to do |format|
      if @employee.valid?
        format.js { render layout: false }
      else
        raise
      end
    end    
  end
  
  def date
    @employee = Employee.find(params[:employee_id])
    @project = Project.find(params[:id])
    @date = Date.parse(params[:date_opt])
    @assigment_day_proj = @employee.project_hours_by_day(:date => @date, :project_id => @project)    
    respond_to do |format|
      format.js {render 'time_form', :layout => false }
    end
    
  end
  
  def calc
    @employee = Employee.find(params[:employee_id])
    @project = Project.find(params[:id])
    @employee.add_time(params.merge({:project => @project}))
    @date = Date.parse(params[:date]) + 1
    respond_to do |format|
      if @employee.valid?
        format.js { render 'time_form', :layout => false}
        format.html { redirect_to employee_path(@employee) }
        format.json
      else
        raise      
      end
    end      
  end
  
  def time_change
    raise
  end
  
  
end