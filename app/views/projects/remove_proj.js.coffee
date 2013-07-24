<% if @customer.errors.any? %>
	errors = "<%= escape_javascript(render(:partial => 'shared/errors', :locals => {:model_obj => @customer} )) %>"
	$('#errors-<%= @project.id %>').html(errors)
<% else %>
	$('#<%= @project.id %>').hide('slow')
<% end %>