module Api
  module V1

    class Product < ActiveRecord::Base

      self.table_name = :products

      acts_as_paranoid

      validates :sku, uniqueness: { conditions: -> { where(deleted_at: nil) } }, allow_blank: false

      has_many :orders

      def self.total_products
        ActiveSupport::NumberHelper::number_to_delimited(Product.count)
      end

      def self.usage_breakdown
        query = Api::V1::Order.complete
        query.joins(:product).select(:product).select(:units).group(:product).sum(:units)
      end

    end

  end
end