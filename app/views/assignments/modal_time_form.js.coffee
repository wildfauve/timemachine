form = "<%= escape_javascript(render(:partial => 'modal_form')) %>"
$("#day-form").dialog({
  autoOpen: true,
  height: 400,
  width: 400,
  modal: true,
  title: 'Edit Time',
  open: ->
    $("#day-form").html(form)
})