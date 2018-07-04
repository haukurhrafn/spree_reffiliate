class AddReferralToSpreeOrders < ActiveRecord::Migration
  def change
    add_column :spree_orders, :referral_id ,:integer

    add_index :spree_orders, :referral_id
  end
end
