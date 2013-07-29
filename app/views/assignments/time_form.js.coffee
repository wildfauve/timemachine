form = "<%= escape_javascript(render(:partial => 'form')) %>"
<% project_div = "##{@project.hyphenise_name}" %>
$('.time-form').slideUp('slow')
$('<%=project_div%>').html(form)
$('<%=project_div%>').slideDown('slow')