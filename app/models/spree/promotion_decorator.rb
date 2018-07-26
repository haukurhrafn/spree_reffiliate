Spree::Promotion.class_eval do

  def already_used?(email, excluded_orders = [])
    [
      :adjustments,
      :line_item_adjustments,
      :shipment_adjustments
    ].any? do |adjustment_type|
      Spree::Order.where(email: email).complete.joins(adjustment_type).where(
        spree_adjustments: {
          source_type: 'Spree::PromotionAction',
          source_id: actions.map(&:id),
          eligible: true
        }
      ).where.not(
        id: excluded_orders.map(&:id)
      ).any?
    end
  end
end
