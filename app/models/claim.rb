class Claim
  
  @@claim_state = [:open, :submitted]
  
  include Mongoid::Document
  include Mongoid::Timestamps  
  
  field :state, type: Symbol  
  
  belongs_to :employee
  embeds_many :expenses
  
  
  def self.claim_state
    @@claim_state
  end

  def self.add_expense(params)
    self.get_latest.add_expense_item(params)
  end
    

  def self.get_latest
    cl = self.where(state: :open).first
    cl ? cl : self.create_it
  end
  
  def self.create_it
    cl = self.new
    cl.state = :open
    cl.save!
    cl
  end

  def name
    self.created_at.strftime('%b-%Y')
  end
  
  def add_expense_item(params)
    self.expenses << Expense.create_it(params)
    save!
    self
  end
  
  def update_expense(params)
    self.expenses.find(params[:id]).update_it(params[:expense])
    save!
    self
  end
  
  def total_value
    @total_value ||= self.expenses.inject(Money.new(0, 'NZD')) {|total, ex| total += ex.amt}
  end
  
  def total_items
    self.expenses.count
  end

  
end