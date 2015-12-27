module Api
  module V1
    module Billing

      class Product < ActiveRecord::Base

        self.table_name = "products"

        acts_as_paranoid

        has_many :line_items

        has_many :orders, through: :line_items

        validates :sku, uniqueness: { conditions: -> { where(deleted_at: nil) } }, allow_blank: true

      end

    end
  end
end