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
    @project = Project.find(params[:id])
    @date = params[:day]
    @timesheer_date_start = params[:date_start]
    respond_to do |format|
      format.js {render 'modal_time_form', :layout => false }
    end    
  end
  
  def update
    @employee = Employee.find(params[:employee_id])
    @project = Project.find(params[:id])
    @employee.add_time(hour: params[:hour], proj: @project, date: params[:date], custom_num: params[:custom_num], fill_value: params[:fill_value], note: params[:note])
    @date = params[:date]    
    @entry = @employee.project_entry_for_day(day: @date, project: @project)    
    @dash = Dashboard.new(:employee => @employee, :date_state => :timesheet, :date_start => params[:timesheet_date_start])        
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
# Params: 
#    {"project"=>"5215303ee4df1c285a000001", "date"=>"2014-03-13", "custom_num"=>"2", "fill-value"=>"", "note"=>"", "costcodes"=>{"532157f7f3654e73bf00000a"=>"1", "53215807f3654e73bf00000b"=>"2", "53215816f3654e73bf00000c"=>"3"}, "commit"=>"Submit", "action"=>"calc", "controller"=>"assignments", "employee_id"=>"51efb2a5e4df1c5434000001", "id"=>"5215303ee4df1c285a000001"}}
    
    @employee = Employee.find(params[:employee_id])
    @project = Project.find(params[:id])
    @employee.add_time(hour: params[:hour], proj: @project, date: params[:date], custom_num: params[:custom_num], fill_value: params[:fill_value], note: params[:note])
    @date = Date.parse(params[:date]) + 1
    respond_to do |format|
      if @employee.valid?
        format.js { render 'time_form', :layout => false}
        format.html { redirect_to employee_path(@employee) }
      else
        raise      
      end
    end      
  end
  
  def time_change
    raise
  end
  
  
end