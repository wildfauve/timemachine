form = "<%= escape_javascript(render(:partial => 'form')) %>"
<% project_div_id = "##{@project.hyphenise_name}" %>
$('#time-form-2').slideUp('slow')
$('#time-form-2').html(form)
$('#time-form-2').slideDown('slow')
$('#date-picker-<%=@project.hyphenise_name%>').datepicker {
	dateFormat: "dd-mm-yy"
}
$('#date-picker-<%=@project.hyphenise_name%>').change ->
  $.ajax({
    type: "POST",
    url: "<%= date_employee_assignment_path(@employee, @project) %>",
    data: { date_opt: $('#date-picker-<%=@project.hyphenise_name%>').val() },
    success:(data) ->
      return false
    error:(data) ->
      comms_error(data)
      return false
  })
comms_error = (data) ->
  alert("error")