module Api
  module V1

    class Order < ActiveRecord::Base

      self.table_name = :orders

      acts_as_paranoid

      belongs_to :user
      belongs_to :product

      after_initialize :set_state, if: :new_record?
      after_initialize :set_units, if: :new_record?

      before_save :update_total

      scope :complete, -> { where(state: :end).where.not(end_at: nil) }

      def self.total_revenue
        ActiveSupport::NumberHelper::number_to_currency(Order.all.sum(:total))
      end

      def self.total_hours
        ActiveSupport::NumberHelper::number_to_delimited(Order.all.sum(:units))
      end

      def self.total_products
        ActiveSupport::NumberHelper::number_to_delimited(Product.count)
      end

      def self.total_customers
        query = Api::V1::Order.complete.joins(:user).group(:user_id).count(:user_id)
        ActiveSupport::NumberHelper::number_to_delimited(query.count)
      end

    private

      def set_state
        self.state = :start
      end

      def set_units
        self.units = 1
      end

      def update_total
        self.total = self.product.unit_price * self.units
      end

    end

  end
end