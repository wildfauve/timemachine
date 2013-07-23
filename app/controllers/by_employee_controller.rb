class ByEmployeeController < ApplicationController
  
  def index
  end
  
  def show
    @employee = Employee.find(params[:id])
  end
  
end