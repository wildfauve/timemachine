form = "<%= escape_javascript(render(partial: 'form')) %>"
$("#costcode-form").dialog({
  autoOpen: true,
  height: 230,
  width: 310,
  modal: true,
  title: 'Project Costcode',
  open: ->
    $("#costcode-form").html(form)
})