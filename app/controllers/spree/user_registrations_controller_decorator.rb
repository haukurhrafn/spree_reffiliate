Spree::UserRegistrationsController.class_eval do

  before_action :check_referral_and_affiliate, only: :create

  # Referral benefit changed to order placement not signup
  # after_action :reset_referral_session, only: :create

  after_action :reset_affiliate_cookie, only: :create

  private

  def check_referral_and_affiliate
    params[:spree_user].merge!(referral_code: cookies[:referral], affiliate_code: cookies[:affiliate])
  end

  def reset_referral_cookie
    if @user.persisted?
      cookies.delete :referral
    end
  end

  def reset_affiliate_cookie
    if @user.persisted? && @user.affiliate? && @user.affiliate.affiliate_commission_rules.order_placement.active.blank?
      cookies.delete :affiliate
    end
  end

end
