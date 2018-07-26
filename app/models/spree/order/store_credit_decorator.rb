Spree::Order::StoreCredit.class_eval do

  def display_total_available_store_credit(currency)
    Spree::Money.new(total_available_store_credit, currency: currency)
  end

end
