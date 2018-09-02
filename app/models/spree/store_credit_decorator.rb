Spree::StoreCredit.class_eval do

  Spree::StoreCredit::REFERRAL_STORE_CREDIT_CATEGORY = 'Vinaboð'
  
  has_one :referred_record

end
