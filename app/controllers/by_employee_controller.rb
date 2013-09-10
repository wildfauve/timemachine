class ByEmployeeController < ApplicationController
  
  def index
    raise
  end
  
  def show
    @employee = Employee.find(params[:id])
    @dash = Dashboard.new(:employee => @employee, :date_state => params[:state], :date_start => params[:date_start])
    respond_to do |format|
      format.html {render 'show'}
    end    
  end
  
  def date
    @employee = Employee.find(params[:id])    
    respond_to do |format|
      format.js {render 'set_date', :layout => false }
    end
  end
  
  def daterefresh
    #session[:employee_id] = params[:id]
    #session[:date_start] = params[:date_start]
    respond_to do |format|
      format.html {redirect_to by_employee_path(params[:id], :date_start => params[:date_start], :state => params[:state])}
    end
  end
  
  def totals
    @employee = Employee.find(params[:id])
    respond_to do |format|
      format.html {render 'project_totals'}
    end
  end
  
  def calc_totals
    @employee = Employee.find(params[:id])
    @employee.refresh_totals
    respond_to do |format|
      format.html {redirect_to totals_by_employee_path(@employee)}
    end    
  end
  
  def summary
    @employee = Employee.find(params[:id])
    @dash = Dashboard.new(:employee => @employee)
    respond_to do |format|
      format.html {render 'summary'}
    end    
  end
  
end