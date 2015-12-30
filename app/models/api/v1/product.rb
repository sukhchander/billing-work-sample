module Api
  module V1

    class Product < ActiveRecord::Base

      self.table_name = "products"

      acts_as_paranoid

      validates :sku, uniqueness: { conditions: -> { where(deleted_at: nil) } }, allow_blank: false

      has_many :orders

    end

  end
end