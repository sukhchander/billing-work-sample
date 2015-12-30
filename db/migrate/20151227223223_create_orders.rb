class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.decimal    :total
      t.string     :state
      t.references :user
      t.references :product
      t.string     :identifier
      t.string     :group_sku
      t.string     :group_identifier
      t.integer    :units
      t.datetime   :starts_at
      t.datetime   :ends_at
      t.timestamps null: false
      t.datetime   :deleted_at
    end
  end
end