module Spree
  class Promotion
    module Rules
      class OneUsePerEmail < PromotionRule
        def applicable?(promotable)
          promotable.is_a?(Spree::Order)
        end

        def eligible?(order, options = {})
          if order.email.present?
            if promotion.already_used?(order.email, [order])
              eligibility_errors.add(:base, eligibility_error_message(:limit_once_per_user))
            end
          else
            # Apply discount before email entered
            # eligibility_errors.add(:base, eligibility_error_message(:no_user_specified))
          end

          eligibility_errors.empty?
        end
      end
    end
  end
end
