module Spree
  class ReferredRecord < Spree::Base
    belongs_to :referral
    belongs_to :user, class_name: Spree.user_class.to_s
    belongs_to :order, class_name: Spree::Order
    belongs_to :affiliate
    belongs_to :store_credit

    validates_presence_of :order
  end
end
