class CreateProducts < ActiveRecord::Migration
  def change
    create_table :products do |t|
      t.string     :sku
      t.string     :name
      t.text       :description
      t.decimal    :unit_price
      t.timestamps null: false
      t.datetime   :deleted_at
    end
  end
end