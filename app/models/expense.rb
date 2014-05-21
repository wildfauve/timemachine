class Expense
  
  @@expense_types = [:phone, :client_entertainment, :staff_meeting, :travel, :parking, :taxi]
  
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :desc, type:  String
  field :amt_cents, type: Integer
  field :expense_type, type: Symbol
  field :customer, :type => Moped::BSON::ObjectId
  
  embedded_in :claim
  
  def self.expense_types
    @@expense_types
  end
  
  def self.create_it(params)
    ex = self.new(params)
    ex.customer = params[:customer]
    ex
  end
  
  def update_it(params)
    self.attributes = params
    self.customer = params[:customer] if params[:customer]
    self
  end
        
  def amt=(amt)
    if /^[\d]+(\.[\d]+){0,1}$/ === amt.gsub(/\$/, "")
      money_amt = Money.parse(amt, "NZD")
      if [Fixnum, Money].include? money_amt.class
        self.amt_cents = money_amt.cents if money_amt.is_a? Money
      else
        errors.add(:amt, "Rate is not a Money value")        
      end
    else
      errors.add(:amt, "Rate does not appear to be a number") unless /^[\d]+(\.[\d]+){0,1}$/ === amt.gsub(/\$/, "")
    end
  end
  
  def amt(options = {})
    raise ArgumentError, 'The "options" arg must be a Hash' unless options.is_a? Hash
    options[:in] ||= 'NZD'
    self.amt_cents.nil? ? cents = 0 : cents = self.amt_cents
    f = Money.new(cents, options[:in])
  end
  
  def related_claim
    Claim.find(claim)
  end
  
  def for_customer
    Customer.find(self.customer) if self.customer.present?
  end
    
end