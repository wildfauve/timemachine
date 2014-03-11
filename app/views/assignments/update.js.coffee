<% if @employee.errors.any? %>
  form = "<%= escape_javascript(render(:partial => 'modal_time_form')) %>"
  $('#dialog-form').html(form)
<% else %>
  cell_html = "<%= escape_javascript(render(partial: 'shared/time_table_cell', locals: {entry: @entry, employee: @employee, proj: @project, day: @date})) %>"
  cell_loc = $("div[data-date='<%= @date %>'][data-proj='<%= @project.name %>']")  
  day_tot = <%= @employee.total_hours_by_day(date: @date).to_s %>
  $('#day-form').dialog('close')
  cell_loc.html(cell_html)  
  $('#total-<%=@date%>').text(day_tot)
  #tot = parseInt($('#total').text())
  #$('#total').text(tot + <%= @entry.hours %>)
<% end %>