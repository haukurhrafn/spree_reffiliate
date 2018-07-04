Spree::CheckoutController.class_eval do
  before_action :set_affilate_or_referral, only: :update
  after_action :clear_session, only: :update

  private
    def set_affilate_or_referral
      if @order.payment?
        if session[:affiliate]
          @order.affiliate = Spree::Affiliate.find_by(path: session[:affiliate])
        elsif session[:referral]
          @order.referral = Spree::Referral.find_by(code: session[:referral])
        end
      end
    end

    def clear_session
      session[:affiliate] = nil if @order.completed?
      session[:referral] = nil if @order.completed?
    end
end
