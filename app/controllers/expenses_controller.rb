class ExpensesController < ApplicationController
  
  def index
    @employee = Employee.find(params[:employee_id])
    respond_to do |format|
      format.html
      format.json
    end
  end
  
  def new
    @expense = Expense.new
  end
  
  def create
    @employee = Employee.find(params[:employee_id])
    @employee.subscribe self
    @employee.create_expense(params)
  end
  
  def show
    @employee = Employee.find(params[:id]) if !@employee
  end
  
  def edit
    @employee = Employee.find(params[:employee_id]) if !@employee
    @claim = Claim.find(params[:claim])
    @expense = @claim.expenses.find(params[:id])
  end
  
  def update
    @employee = Employee.find(params[:employee_id])
    @employee.subscribe self
    @employee.update_expense(params)    
  end
  
  def destroy
    @employee = Employee.find(params[:employee_id]).delete_expense(params)
    respond_to do |format|
      if @employee.valid?
        format.html { redirect_to employee_expenses_path }
        format.json
      else
        format.html { render action: "edit" }
        format.json
      end
    end          
  end
  
  def entered
    @employee = Employee.find(params[:employee_id]).set_expense_entered(params)
    @claim = @employee.claim
    respond_to do |format|
      if @employee.valid?
        format.html { render 'claims/show' }
      else
        format.html { render action: "edit" }
      end
    end    
  end  
  
  def successful_create_expense_event(claim)
    redirect_to(employee_claim_path(@employee, claim))
  end

  def successful_update_expense_event(claim)
    redirect_to(employee_claim_path(@employee, claim))
  end

  
end