class Dashboard
  
  attr_accessor :day_total, :proj_total, :summ_by_date, :summ_by_project, :employee, :date_start, :cce_total
  
  def initialize(params)
    @employee.nil? ? @employee = Employee.where(name: "Col").first : @employee = params[:employee]
    @date_start = Date.parse(params[:date_start]) if params[:date_start]
    @customer = params[:customer]
    set_date_range(params[:date_state])
  end

# ==> summ_by_project
# [{:project=>"Solution Architecture", :dates=>{"2013-07-22"=>8, "2013-07-23"=>8, "2013-07-24"=>7, "2013-07-25"=>5, "2013-07-26"=>6}},
# {:project=>"Transformation Programme", :dates=>{"2013-07-22"=>0, "2013-07-23"=>0, "2013-07-24"=>0, "2013-07-25"=>0, "2013-07-26"=>0}},
# {:project=>"Optimise HR", :dates=>{"2013-07-22"=>0, "2013-07-23"=>0, "2013-07-24"=>0, "2013-07-25"=>0, "2013-07-26"=>0}},
# {:project=>"Architecture Assessment", :dates=>{"2013-07-22"=>0, "2013-07-23"=>0, "2013-07-24"=>0, "2013-07-25"=>0, "2013-07-26"=>0}}]

# proj_total
# {"51f05fb5e4df1c834a000008"=>17.0, "5215305be4df1c285a000002"=>1.0, "5215303ee4df1c285a000001"=>16.0}

# ==> summ_by_date

# ==> dashboard.day_total
# {"2013-07-22"=>8, "2013-07-23"=>8, "2013-07-24"=>7, "2013-07-25"=>5, "2013-07-26"=>6}  

  def calc_summary
    return self if @summ_by_project || @summ_by_date
    @summ_by_project = []
    @day_total = {}
    @proj_total = {}
    @cce_total = {}    
    @summ_by_date = []
    if @customer
      proj_list = @customer.projects.sort {|x,y| x.customer.name <=> y.customer.name}
    else
      proj_list = @employee.projects.sort {|x,y| x.customer.name <=> y.customer.name}
    end
    
    # Summaise by Project
    # {:project=>#<Project _id: 51f05fb5e4df1c834a000008, _type: nil, created_at: 2013-07-24 23:13:57 UTC, updated_at: 2013-08-01 20:54:33 UTC, name: "Solution Architecture", desc: "", billable: true, customer_id: "51efb2ade4df1cead0000003", employee_ids: ["51efb2a5e4df1c5434000001"]>, :dates=>{"2014-05-01"=>#<Entry _id: 5363005ef3654e7f07000008, _type: nil, created_at: 2014-05-02 02:18:06 UTC, updated_at: 2014-05-02 02:18:06 UTC, hours: 3.0, project: "51f05fb5e4df1c834a000008", note: nil>, "2014-05-02"=>#<Entry _id: 5363004df3654e7f07000007, _type: nil, created_at: nil, updated_at: nil, hours: 3.0, project: "51f05fb5e4df1c834a000008", note: nil>, "2014-05-05"=>#<Entry _id: 5367527cf3654e9a65000003, _type: nil, created_at: 2014-05-05 08:57:32 UTC, updated_at: 2014-05-05 08:57:32 UTC, hours: 3.0, project: "51f05fb5e4df1c834a000008", note: nil>}}
    
    proj_list.each do |proj|
      line, dates = {}, {}
      line[:project] = proj
      @day_range.each do |day|
        
        # Find hours for the day for the project
        e = entry(day: day, project: proj)
        #hours = @employee.project_hours_by_day(:project_id => proj.id, :date => day)
        if e
          dates[day.to_s] = e
          #
          # day_total = {"2014-05-01"=>7.0, "2014-05-02"=>7.0, "2014-05-05"=>3.0}
          #
          @day_total[day.to_s] ? @day_total[day.to_s] += e.hours : @day_total[day.to_s] = e.hours
          #
          # proj_total = {"51f05fb5e4df1c834a000008"=>9.0, "5215303ee4df1c285a000001"=>8.0}
          #          
          @proj_total[proj.id] ? @proj_total[proj.id] += e.hours : @proj_total[proj.id] = e.hours
          
          # Sum all the costcode entries
          
          # @cce_total = {"53215807f3654e73bf00000b"=>18.0, "53215816f3654e73bf00000c"=>18.0, "532157f7f3654e73bf00000a"=>9.0}
          if !e.costcodeentries.empty?
            e.costcodeentries.each {|cce| @cce_total[cce.costcode] ? @cce_total[cce.costcode] += cce.hours : @cce_total[cce.costcode] = cce.hours}
          end
          
        end
        
      end
      if !dates.empty?
        line[:dates] = dates
        @summ_by_project << line
      end
		end
    
    # Summarise By Date
    # {:date=>Tue, 06 May 2014, :projects=>{:project=>{:project=>#<Project _id: 5215303ee4df1c285a000001, _type: nil, created_at: 2013-08-21 21:25:18 UTC, updated_at: 2014-03-13 07:03:25 UTC, name: "Co-brand Programme", desc: "", billable: true, customer_id: "51efb2ade4df1cead0000003", employee_ids: ["51efb2a5e4df1c5434000001"]>, :dates=>{"2014-05-01"=>4.0, "2014-05-02"=>4.0}}, :total=>nil}}    
    
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
      if state == :timesheet && @date_start.nil?
        date_range = calc_date_range(Date.today)
      elsif state == :timesheet && !@date_start.nil?
        date_range = calc_date_range(@date_start)
      elsif state == :invoice && @date_start.nil?  
        date_range = Date.today.change({day: 1})..Date.today.end_of_month
      elsif state == :invoice && !@date_start.nil? 
        date_range = @date_start.change({day: 1})..@date_start.end_of_month
      elsif @date_start
        date_range = calc_date_range(@date_start)
      elsif state.nil? && @date_start.nil?
        date_range = nil 
      else
        raise
      end
    end
    if date_range
      @day_range = @employee.days.select {|d| date_range === d.date}.collect {|d| d.date}.sort {|x,y| x <=> y}
      @day_range << date_range.first if @day_range.empty?
      @day_range << @day_range.last + 1 if @day_range.last != date_range.last
    else
      @day_range = @employee.all_days
    end
  end  

  def calc_date_range(date, period: 15)
    today = date
    start_month = (today.change({:day => 1})..today.change({:day => period}))
    end_month = (today.change({:day => period + 1})..today.end_of_month)
    today <= date.change({:day => period}) ? start_month : end_month
  end
  
  def project_total(project)
    @proj_total[project.id]
  end
  
  def hours_for_day(day, proj)
    p = @summ_by_project.select {|p| p[:project].id == proj[:project].id}.first
    hours = p[:dates].select{|d, n| d == day.to_s}[day.to_s].try(:hours)
    hours
  end
  
  def entry(day: nil, project: nil)
    @employee.project_entry_for_day(day: day, project: project)
  end
  
  def total_for_day(day)
    self.day_total.select {|d, n| d == day.to_s}[day.to_s]
  end
  
  def overall_total
    @proj_total.inject(0.0) {|r, (k,v)| r += v}
  end
  
  def timesheet_total
    @employee.days.select {|d| @day_range.include?(d.date) }.inject(0.0) {|t, d| t += d.total_hours }
  end
  
  def day_range
    @day_range.empty? ? [Date.today] : @day_range 
  end
    
  def to_csv
    CSV.generate do |csv|
      csv << [" "] + self.day_range
      self.calc_summary.summ_by_project.each do |proj|
        row = []
        row << proj[:project].name
        self.day_range.each {|day| row << self.hours_for_day(day, proj).to_s}
        row << self.proj_total[proj[:project].id]  
        csv << row
        proj[:project].costcodes.each do |code|
          row = []
          row << "#{code.code}: #{code.name}"
          self.day_range.each {|day| row << self.entry(day: day, project: proj[:project]).try(:cost_code, code).try(:hours).to_s}
          row << @cce_total[code.id]
          csv << row
        end 
      end    
    end
  end
  
end
