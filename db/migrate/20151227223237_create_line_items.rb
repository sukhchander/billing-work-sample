class CreateLineItems < ActiveRecord::Migration
  def change
    create_table :line_items do |t|
      t.references :product
      t.references :order
      t.integer    :units
      t.decimal    :price
      t.timestamps null: false
      t.datetime   :deleted_at
    end
  end
end