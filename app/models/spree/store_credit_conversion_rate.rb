module Spree
  class StoreCreditConversionRate < Spree::Base
    validates :rate, presence: true
    validates :rate, numericality: { greater_than: 0, less_than_or_equal_to: 100, allow_nil: true }
  end
end
