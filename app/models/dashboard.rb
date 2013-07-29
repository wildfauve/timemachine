class Dashboard
  
  attr_accessor :day_range, :day_total
  
  def initialize(params)
    @employee = params[:employee]
    @date_start = Date.parse(params[:date_start]) if params[:date_start]
    set_date_range(params[:date_state])
  end

# ==> summ  
# [{:project=>"Solution Architecture", :dates=>{"2013-07-22"=>8, "2013-07-23"=>8, "2013-07-24"=>7, "2013-07-25"=>5, "2013-07-26"=>6}},
# {:project=>"Transformation Programme", :dates=>{"2013-07-22"=>0, "2013-07-23"=>0, "2013-07-24"=>0, "2013-07-25"=>0, "2013-07-26"=>0}},
# {:project=>"Optimise HR", :dates=>{"2013-07-22"=>0, "2013-07-23"=>0, "2013-07-24"=>0, "2013-07-25"=>0, "2013-07-26"=>0}},
# {:project=>"Architecture Assessment", :dates=>{"2013-07-22"=>0, "2013-07-23"=>0, "2013-07-24"=>0, "2013-07-25"=>0, "2013-07-26"=>0}}]

# ==> day_total
# {"2013-07-22"=>8, "2013-07-23"=>8, "2013-07-24"=>7, "2013-07-25"=>5, "2013-07-26"=>6}  

  def summary
    summ = []
    @day_total = {}
    @employee.projects.each  do |proj|
      line, dates = {}, {}
      line[:project] = proj.name
      @day_range.each do |day|
        hours = @employee.project_hours_by_day(:project_id => proj.id, :date => day)
        dates[day.to_s] = hours
        @day_total[day.to_s] ? @day_total[day.to_s] += hours : @day_total[day.to_s] = hours
      end
      line[:dates] = dates
      summ << line
		end
		summ
  end
  
  def set_date_range(state)
    if state
      if state == "period"
        date_ranage = calc_date_range(Date.today)
      end
    else
      @date_start ? date_range = calc_date_range(@date_start) : date_range = nil
    end
    if date_range
      @day_range = @employee.days.select {|d| date_range === d.date}.collect {|d| d.date}.sort {|x,y| x <=> y}
    else
      @day_range = @employee.days.collect {|d| d.date}.sort {|x,y| x <=> y}
    end
  end  

  def calc_date_range(date)
    today = date
    start_month = (today.change({:day => 1})..today.change({:day => 15}))
    end_month = (today.change({:day => 15})..today.end_of_month)
    today <= date.change({:day => 15}) ? start_month : end_month
  end
  
end
