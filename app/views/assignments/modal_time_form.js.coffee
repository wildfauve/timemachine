form = "<%= escape_javascript(render(:partial => 'modal_form')) %>"
$("#day-form").dialog({
  autoOpen: true,
  height: 200,
  width: 300,
  modal: true,
  title: 'Edit Time',
  open: ->
    $("#day-form").html(form)
})