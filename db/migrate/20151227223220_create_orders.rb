class CreateOrders < ActiveRecord::Migration
  def change
    create_table :orders do |t|
      t.decimal    :total
      t.string     :state
      t.references :user
      t.datetime   :completed_at
      t.timestamps null: false
      t.datetime   :deleted_at
    end
  end
end