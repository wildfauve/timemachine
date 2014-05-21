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
  end
  
  def paid
  end
 
  
end