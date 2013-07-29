form = "<%= escape_javascript(render(:partial => 'date_form')) %>"
$('#date-form').hide
$('#date-form').html(form)
$('#date-form').slideDown('slow')
$('dd').removeClass('active')
$("#setdate").addClass("active")
$('.date-picker').datepicker {
	dateFormat: "dd-mm-yy"
}
