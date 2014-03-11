form = "<%= escape_javascript(render(:partial => 'modal_form')) %>"
$("#project-form").dialog({
  autoOpen: true,
  height: 250,
  width: 350,
  modal: true,
  title: 'Edit Time',
  open: ->
    $("#project-form").html(form)
})