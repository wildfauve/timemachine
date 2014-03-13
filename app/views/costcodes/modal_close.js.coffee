<% if @project.errors.any? %>
  form = "<%= escape_javascript(render(:partial => 'form')) %>"
  $('#').html(form)
<% else %>
  table = "<%= escape_javascript(render(partial: 'for_project', locals: {proj: @project})) %>"
  $('#costcode-form').dialog('close')
  $("#<%="proj-table-#{@project.id}" %>").html(table)  
<% end %>