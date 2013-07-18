module ApplicationHelper
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
  
  def project_list_select
    Customer.all_projects.map{|p| [p.name, p.id]}
  end
  
  
end
