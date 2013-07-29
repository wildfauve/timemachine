form = "<%= escape_javascript(render(:partial => 'form' )) %>"
$('#status-<%= @project.id %>').hide()
$('#status-<%= @project.id %>').html(form)
$('#status-<%= @project.id %>').slideDown('slow')