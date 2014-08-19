class Api::CustomersController < Api::ApplicationController
  
  def index
    respond_to do |format|
      format.json
    end
  end
end


