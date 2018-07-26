class CreateSpreeStoreCreditConversion < ActiveRecord::Migration
  def change
    create_table :spree_store_credit_conversion_rates do |t|
      t.string :currency
      t.decimal :rate, default: 1
    end
  end
end
