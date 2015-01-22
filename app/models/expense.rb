class Expense
  
  @@expense_types = [:phone, :client_entertainment, :staff_meeting, :travel, :parking, :taxi, :milage, :office_supplies]
  
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :desc, type:  String
  field :amt_cents, type: Integer
  field :expense_type, type: Symbol
  field :customer, :type => BSON::ObjectId
  field :entered, type: Boolean
  
  embedded_in :claim
  
  def self.expense_types
    @@expense_types
  end
  
  def self.create_it(params)
    ex = self.new
    ex.update_attrs(params)
    ex
  end
  
  def update_it(params)
    self.update_attrs(params)
    self
  end
      
  def update_attrs(params)
    self.desc = params[:desc]
    self.amt = params[:amt]
    self.expense_type = params[:expense_type]
    self.customer = params[:customer] if params[:customer].present?
  end  
  
  def amt=(amt)
    if /^[\d]+(\.[\d]+){0,1}$/ === amt.gsub(/\$/, "")
      money_amt = Monetize.parse(amt, "NZD")
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
  
  def set_entered
    self.entered = true
  end
    
end