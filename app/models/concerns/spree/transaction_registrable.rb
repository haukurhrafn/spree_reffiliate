module Spree::TransactionRegistrable
  extend ActiveSupport::Concern
    included do
      def register_commission_transaction(referral_source)
        if referral_source.is_a?(Spree::Affiliate) && affiliate_commission_rule_present?(affiliate)
          self.transactions.create!(affiliate: referral_source, locked: false)
        elsif referral_source.is_a(Spree::Referral) && referral_commission_rule_present?(referral)
          self.transactions.create!(referral: referral_source, locked: false)
        end
      end

      def affiliate_commission_rule_present?(affiliate)
        if self.class.eql? Spree::User
          commission_rule_id = Spree::CommissionRule.user_registration.try(:id)
        elsif self.class.eql? Spree::Order
          commission_rule_id = Spree::CommissionRule.order_placement.try(:id)
        end
        affiliate.affiliate_commission_rules.active.where(commission_rule_id: commission_rule_id).present?
      end

      def referral_commission_rule_present?(referral)
        if self.class.eql? Spree::User
          commission_rule_id = Spree::CommissionRule.user_registration.try(:id)
        elsif self.class.eql? Spree::Order
          commission_rule_id = Spree::CommissionRule.order_placement.try(:id)
        end
        referral.referral_commission_rules.active.where(commission_rule_id: commission_rule_id).present?
      end

    end
end
