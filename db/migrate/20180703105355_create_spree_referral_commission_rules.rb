class CreateSpreeReferralCommissionRules < ActiveRecord::Migration
  def change
    create_table :spree_referral_commission_rules do |t|
      t.references :commission_rule, index: true
      t.references :referral, index: true

      t.decimal :rate
      t.decimal :fixed_commission
      t.boolean :active, default: false, null: false, index: true

      t.timestamp null: false
    end
  end
end
