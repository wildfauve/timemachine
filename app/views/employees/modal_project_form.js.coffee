form = "<%= escape_javascript(render(:partial => 'modal_form')) %>"
$("#project-form").dialog({
  autoOpen: true,
  height: 350,
  width: 350,
  modal: true,
  title: 'Edit Assignment',
  open: ->
    $("#project-form").html(form)
})