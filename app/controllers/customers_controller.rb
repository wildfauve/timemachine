class CustomersController < ApplicationController
  
  def index
    @customers = Customer.all
  end
  
  def new
    @customer = Customer.new
  end
  
  def create
    @customer = Customer.create_it(params[:customer])
    respond_to do |format|
      if @customer.valid?
        format.html { redirect_to customers_path }
        format.json
      else
        format.html { render action: "new" }
        format.json
      end
    end      
  end
  
  def show
  end
  
  def edit
    @customer = Customer.find(params[:id])
  end
  
  def update
  end
  
  def invoice
    @customer = Customer.find(params[:id])
    @dash = Dashboard.new(employee: @employee, customer: @customer, date_state: params[:state], date_start: params[:date_start])
    respond_to do |format|
      format.html {render 'show'}
    end    
  end
  
  def export
    @customer = Customer.find(params[:id])
    @dash = Dashboard.new(customer: @customer, date_state: :invoice, date_start: params[:date_start])
    respond_to do |format|
      format.csv { render text: @dash.to_csv }
    end    
  end
  
  
end