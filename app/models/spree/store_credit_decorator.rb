Spree::StoreCredit.class_eval do
  REFERRAL_STORE_CREDIT_CATEGORY = 'Referral Credit'

  has_one :referred_record

  after_commit :send_credit_reward_information, on: :create, if: :referral?

  def display_amount
    Spree::Money.new(amount, currency: currency)
  end

  def convert_store_credits_currency(currency)
    if user && user.store_credits.any?
      user.store_credits.each do |store_credit|
        if store_credit.currency != currency
          store_credit.amount = store_credit.amount * Spree::StoreCreditConversionRate.find_by(currency: currency).rate
          store_credit.amount_used = store_credit.amount_used * Spree::StoreCreditConversionRate.find_by(currency: currency).rate
          store_credit.amount_authorized = store_credit.amount_authorized * Spree::StoreCreditConversionRate.find_by(currency: currency).rate
          store_credit.currency = currency
          store_credit.save
        end
      end
    end
  end

  private
    def referral?
      category.try(:name) == REFERRAL_STORE_CREDIT_CATEGORY
    end

    def send_credit_reward_information
      Spree::ReferralMailer.credits_awarded(user, display_amount.to_s).deliver_later
    end
end
