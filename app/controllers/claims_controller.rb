class ClaimsController < ApplicationController
  
  def index
    @employee = Employee.find(params[:employee_id])
    @claims = @employee.claims
    respond_to do |format|
      format.html
      format.json
    end
  end
  

  def submitted
  end
  
  def paid
  end
 
  
end