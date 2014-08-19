class Projsummary
  
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :total_hours, :type => Float
  field :start_date, :type => Date
  field :end_date, :type => Date
  field :viewable, :type => Boolean
  field :project, :type => Moped::BSON::ObjectId
  field :rate_cents, type: Integer
  field :hours_budget, type: Integer
  belongs_to :employee, :inverse_of => :projsummaries

  def self.store(proj)
    projectsum = self.find_or_create_by(:project => proj[:project].id)
    projectsum.summ(proj[:dates])
    return projectsum
  end
  
  def summ(dates)
    d = dates.select {|date, entry| entry.hours > 0}.keys
    self.start_date = d.min
    self.end_date = d.max
    self.total_hours = dates.inject(0) {|count, (date,entry)| count += entry.hours}
  end
  
  def assigned_project
    Project.find(self.project)
  end
  
  def total_utilisation
    if self.start_date
      (self.total_hours / 8) / (Utilities.working_days_between(self.start_date, self.end_date) + 1) * 100
    else
      0
    end
  end
  
  def duration
    self.start_date ? Utilities.working_days_between(self.start_date, self.end_date) : 0
  end
  
  def avg_effort
    if self.start_date
      dur = self.end_date.mjd - self.start_date.mjd
      dur > 7 ? self.total_hours / (dur.to_f / 7) : self.total_hours
    else
      0
    end
  end
  
  def total_earnings
    self.total_hours * self.rate.to_f if self.rate > Money.new(0, 'NZD')
  end
  
  def mod(params)
    self.rate = params[:rate]
    self.viewable = params[:viewable]
    self.hours_budget = params[:hours_budget]
    self.save
  end
  
  def rate=(rate)
    if /^[\d]+(\.[\d]+){0,1}$/ === rate.gsub(/\$/, "")
      money_rate = Money.parse(rate, "NZD")
      if [Fixnum, Money].include? money_rate.class
        self.rate_cents = money_rate.cents if money_rate.is_a? Money
      else
        errors.add(:rate, "Rate is not a Money value")        
      end
    else
      errors.add(:rate, "Rate does not appear to be a number") unless /^[\d]+(\.[\d]+){0,1}$/ === rate.gsub(/\$/, "")
    end
  end
  
  def rate(options = {})
    raise ArgumentError, 'The "options" arg must be a Hash' unless options.is_a? Hash
    options[:in] ||= 'NZD'
    self.rate_cents.nil? ? cents = 0 : cents = self.rate_cents
    Money.new(cents, options[:in])
  end


  
  
end