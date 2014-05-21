module ApplicationHelper

  def title(page_title, sup_title = "")
      content_for(:title, page_title.to_s + ":" + sup_title.to_s )
  end


  def project_list
    pl = Customer.all_projects
    content_tag(:ul, :class => 'dropdown') do
      pl.each do |p|
        concat(content_tag(:li) do
          concat(link_to(p.name,customer_project_path(p.customer, p))) 
        end)
      end
    end
  end
  
  def assigned_customer_list_select(employee)
    employee.assigned_customers.map{|c| [c.name, c.id]}
  end
  
  
  def project_list_select
    Customer.all_projects.map{|p| [p.name, p.id]}
  end

  def expense_type_select
    Expense.expense_types.map {|et| [et.to_s, et]}
  end

  def employee_list_select
    Employee.all.map{|e| [e.name, e.id]}
  end
  
  def selected_employee(user)
    user.employee.present? ? user.employee.id : nil
  end
  
  def role_list
    [["Admin", 'admin'],["User", 'user']] 
  end
  
  def date_list
    list = []
    (Date.today-15..Date.today).each {|d| list << [d, d]}
    return list
  end
  
  def test_location(params, test)
    return "active" if test == :show && params[:action] == 'show' && params[:controller] == "employees"
    return "active" if test == :summary_all && !params[:state] && params[:action] == 'summary' && params[:controller] == "by_employee"
    return "active" if test == :timesheet && params[:state]
    return "active" if test == :projsummary && params[:action] == 'totals' && params[:controller] == "by_employee"    
    return "active" if test == :expenses && params[:controller] == "expenses"   
    return "active" if test == :claims && params[:controller] == "claims"
    ""    
  end
  
end
