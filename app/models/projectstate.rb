class Projectstate
  
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :viewable, :type => Boolean
  field :project, :type => Moped::BSON::ObjectId
  field :rate_cents, type: Integer
  
  embedded_in :employee, :inverse_of => :projectstates

  def mod(params)
    self.rate = params[:rate]
    self.viewable = params[:viewable]
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