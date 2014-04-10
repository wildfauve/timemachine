<% if @employee.errors.any? %>
  form = "<%= escape_javascript(render(:partial => 'modal_time_form')) %>"
  $('#dialog-form').html(form)
<% else %>
  cell_html = "<%= escape_javascript(render(partial: 'shared/time_table_cell', locals: {entry: @entry, employee: @employee, proj: @project, day: @date})) %>"
  cell_loc = $(".time-entry[data-date='<%= @date %>'][data-proj='<%= @project.name %>']")  
  day_tot = <%= @employee.total_hours_by_day(date: @date).to_s %>
  $('#day-form').dialog('close')
  cell_loc.html(cell_html)
  <% for cost_code_entry in @entry.costcodeentries %>
  cost_html = "<%= escape_javascript(render(partial: 'shared/time_table_cost_cell', locals: {entry: @entry, proj: @project, day: @date, code: cost_code_entry.costcode})) %>"
  cost_cell_loc = $(".costentry[data-date='<%= @date %>'][data-proj='<%= @project.name %>'][data-code-id='<%= cost_code_entry.costcode %>']")
  cell_loc = $(".time-entry[data-date='<%= @date %>'][data-proj='<%= @project.name %>']")
  cost_cell_loc.html(cost_html)
  <% end %>
  $('#total-<%=@date%>').text(day_tot)
  $('#total').text(<%= @dash.timesheet_total %> )
<% end %>