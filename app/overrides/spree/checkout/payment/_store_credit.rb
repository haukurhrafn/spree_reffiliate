Deface::Override.new(
  virtual_path: "spree/checkout/payment/_storecredit",
  name: "multi_currency_store_credit",
  replace: "[data-hook='checkout_payment_store_credit_available']",
  partial: 'spree/checkout/payment/multi_currency_store_credit'
)
