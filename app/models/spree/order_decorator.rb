Spree::Order.class_eval do
  include Spree::TransactionRegistrable

  has_many :transactions, as: :commissionable, class_name: 'Spree::CommissionTransaction', dependent: :restrict_with_error
  belongs_to :affiliate, class_name: 'Spree::Affiliate'
  belongs_to :referral, class_name: 'Spree::Referral'

  state_machine.after_transition to: :complete, do: :create_commission_transaction
  state_machine.before_transition to: :complete, do: :create_referral_benefit

  def referred?
    referral.present?
  end

  def affiliated?
    affiliate.present?
  end

  private
    def create_commission_transaction
      register_commission_transaction(affiliate) if affiliate.present?
    end

    def create_referral_benefit
      if referral.present? && referrer_eligible?(referral.user) && purchaser_eligible?
        store_credit = create_store_credits(referral.user)
        referral.referred_records.create(order: self, store_credit_id: store_credit.try(:id))
      end
    end

    def convert_store_credits_currency
      if user && user.store_credits.any?
        user.store_credits.each do |store_credit|
          if store_credit.currency != currency
            conversion_ratio = Spree::StoreCreditConversionRate.find_by(currency: currency).rate / Spree::StoreCreditConversionRate.find_by(currency: store_credit.currency).rate
            store_credit.amount = store_credit.amount * conversion_ratio
            store_credit.amount_used = store_credit.amount_used * conversion_ratio
            store_credit.amount_authorized = store_credit.amount_authorized * conversion_ratio
            store_credit.currency = currency
            store_credit.save
          end
        end
      end
    end

    def create_store_credits(referrer)
      referrer.store_credits.create(amount: referral_amount(referrer),
                                    category_id: referral_store_credit_category.try(:id),
                                    created_by: Spree::User.admin.try(:first),
                                    currency: Spree::Config.currency)
    end

    def referral_amount(referrer)
      referrer.referral_credits || Spree::Config[:referral_credits]
    end

    def referral_store_credit_category
      @store_credit_category ||= Spree::StoreCreditCategory.find_or_create_by(name: Spree::StoreCredit::REFERRAL_STORE_CREDIT_CATEGORY)
    end

    def referrer_eligible?(user)
      Spree::Config[:referrer_benefit_enabled] && user.referrer_benefit_enabled
    end

    def purchaser_eligible?
      # Must be first order placed by user
      return true unless Spree::Order.exists?(email: email, state: 'complete')
    end

end
