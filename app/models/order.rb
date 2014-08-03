class Order < ActiveRecord::Base
  has_many :line_items, dependent: :destroy
  belongs_to :cart
  attr_accessor :card_number, :card_verification
  validate :validate_card, :on => :create

  PAYMENT_TYPES = ["Check","Credit Card", "Purchase Order"]
  validates :name, :address, :email, presence: true
  validates :pay_type, inclusion: PAYMENT_TYPES

  def add_line_items_from_cart(cart)
    cart.line_items.each do |item|
      item.cart_id = nil
      line_items << item
    end
  end

  def purchase
    response = GATEWAY.purchase(price_in_cents, credit_card, :ip => ip_address)
    cart.update_attribute(:purchased_at, Time.now) if response.success?
    response.success?
    # response = GATEWAY.purchase(price_in_cents, credit_card, :ip => ip_address)
    # transactions.create!(:action => "purchase", :amount => price_in_cents, :response => response)
    # cart.update_attribute(:purchased_at, Time.now) if response.success?
    # response.success?
  end

  def price_in_cents
    (cart.total_price*100).round
  end
  
  def validate_card
    unless credit_card.valid?
      credit_card.errors.full_messages.each do |message|
        errors[:base] << message
      end
    end
  end

  def credit_card
    @credit_card ||= ActiveMerchant::Billing::CreditCard.new(
      :brand => card_type,
      :number => card_number,
      :verification_value => card_verification,
      :month => card_expires.month,
      :year => card_expires.year,
      :first_name => first_name,
      :last_name => last_name
      )
  end
end
