class Utilities
  
  def self.working_days_between(start_d,end_d)
    (start_d..end_d).count {|d| d.wday >= 1 && d.wday <= 5}
  end

  
end