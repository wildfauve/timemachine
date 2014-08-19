class Api::ApplicationController < ApplicationController

  rescue_from Mongoid::Errors::DocumentNotFound, with: :record_not_found
  rescue_from Mongoid::Errors::Validations, with: :invalid_request
  #rescue_from Exceptions::Standard, :with => :invalid_suspect_profile_parameters
  
  respond_to :json

  def record_not_found
    error(:not_found, :not_found, "URL does not represent a resource")
  end
  
  def invalid_request
    error(:bad_request, :bad_request, "The request is badly formatted")
  end
  
  #def record_not_found
  #  head :not_found
  #end
  
  def error(status, code, message)
    render :json => {:response_type => "ERROR", :response_code => code, :message => message}.to_json, :status => status
  end
    

end
