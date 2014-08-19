class ClaimsController < ApplicationController
  
  def index
    @claims = @employee.claims
    respond_to do |format|
      format.html
    end
  end
  
  def show
    @claim = @employee.claims.find(params[:id])
    respond_to do |format|
      format.html
    end    
  end
  

  def submitted
    @employee = Employee.find(params[:employee_id]).set_claim_state_change(claim_id: params[:claim_id], state: :submitted)
    respond_to do |format|
      if @employee.valid?
        format.html { redirect_to employee_claims_path(@employee) }
      else
        raise
      end
    end        
  end
  
  def paid
    @employee = Employee.find(params[:employee_id]).set_claim_state_change(claim_id: params[:claim_id], state: :paid)
    respond_to do |format|
      if @employee.valid?
        format.html { redirect_to employee_claims_path(@employee) }
      else
        raise
      end
    end            
  end
 
  
end