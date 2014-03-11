<% if @project.errors.any? %>
  form = "<%= escape_javascript(render(:partial => 'form')) %>"
  $('#').html(form)
<% else %>
  $('#costcode-form').dialog('close')
<% end %>