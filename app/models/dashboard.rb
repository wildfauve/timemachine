class Dashboard
  
  attr_accessor :day_range, :day_total, :proj_total, :summ_by_date, :summ_by_project
  
  def initialize(params)
    @employee = params[:employee]
    @date_start = Date.parse(params[:date_start]) if params[:date_start]
    set_date_range(params[:date_state])
  end

# ==> summ_by_project
# [{:project=>"Solution Architecture", :dates=>{"2013-07-22"=>8, "2013-07-23"=>8, "2013-07-24"=>7, "2013-07-25"=>5, "2013-07-26"=>6}},
# {:project=>"Transformation Programme", :dates=>{"2013-07-22"=>0, "2013-07-23"=>0, "2013-07-24"=>0, "2013-07-25"=>0, "2013-07-26"=>0}},
# {:project=>"Optimise HR", :dates=>{"2013-07-22"=>0, "2013-07-23"=>0, "2013-07-24"=>0, "2013-07-25"=>0, "2013-07-26"=>0}},
# {:project=>"Architecture Assessment", :dates=>{"2013-07-22"=>0, "2013-07-23"=>0, "2013-07-24"=>0, "2013-07-25"=>0, "2013-07-26"=>0}}]

# ==> summ_by_date

# ==> dashboard.day_total
# {"2013-07-22"=>8, "2013-07-23"=>8, "2013-07-24"=>7, "2013-07-25"=>5, "2013-07-26"=>6}  

  def calc_summary
    return self if @summ_by_project || @summ_by_date
    @summ_by_project = []
    @day_total = {}
    @proj_total = {}
    @summ_by_date = []
    @employee.projects.each  do |proj|
      line, dates = {}, {}
      line[:project] = proj
      @day_range.each do |day|
        hours = @employee.project_hours_by_day(:project_id => proj.id, :date => day)
        dates[day.to_s] = hours
        @day_total[day.to_s] ? @day_total[day.to_s] += hours : @day_total[day.to_s] = hours
        @proj_total[proj.id] ? @proj_total[proj.id] += hours : @proj_total[proj.id] = hours
      end
      line[:dates] = dates
      @summ_by_project << line
		end
		date_line = {}
		@day_range.each do |day|
		  date_line[:date] = day
		  proj_line = {}
		  @summ_by_project.each do |proj|
		    selected = proj[:dates].select {|d, v| d == day}
		    proj_line[:project] = proj
		    proj_line[:total] = selected[day]
	    end
	    date_line[:projects] = proj_line
	    @summ_by_date << date_line
	  end
		self
  end
  
  def set_date_range(state)
    if state
      date_range = calc_date_range(Date.today) if state == "timesheet"
    else
      @date_start ? date_range = calc_date_range(@date_start) : date_range = nil
    end
    if date_range
      @day_range = @employee.days.select {|d| date_range === d.date}.collect {|d| d.date}.sort {|x,y| x <=> y}
    else
      @day_range = @employee.all_days
    end
  end  

  def calc_date_range(date)
    today = date
    start_month = (today.change({:day => 1})..today.change({:day => 15}))
    end_month = (today.change({:day => 15})..today.end_of_month)
    today <= date.change({:day => 15}) ? start_month : end_month
  end
  
end
