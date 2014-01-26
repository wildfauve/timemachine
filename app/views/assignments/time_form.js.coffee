form = "<%= escape_javascript(render(:partial => 'form')) %>"
<% project_div_id = "##{@project.hyphenise_name}" %>
# $('.time-form').slideUp('slow')
# $('<%= project_div_id %>').html(form)
$('#time-form-2').slideUp('slow')
$('#time-form-2').html(form)
$('#time-form-2').slideDown('slow')
# $('<%= project_div_id %>').slideDown('slow')
$('#date-picker-<%=@project.hyphenise_name%>').datepicker {
	dateFormat: "dd-mm-yy"
}