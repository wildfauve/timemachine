form = "<%= escape_javascript(render(:partial => 'form')) %>"
<% project_div = "##{@project.name}" %>
$('.time-form').slideUp('slow')
$('<%=project_div%>').html(form)
$('<%=project_div%>').slideDown('slow')