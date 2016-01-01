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

      def self.total_revenue(date_range=nil)
        ActiveSupport::NumberHelper::number_to_currency(Order.complete.sum(:total))
      end

      def self.total_hours(date_range=nil)
        ActiveSupport::NumberHelper::number_to_delimited(Order.complete.all.sum(:units))
      end

      def self.total_products(date_range=nil)
        ActiveSupport::NumberHelper::number_to_delimited(Product.count)
      end

      def self.total_customers(date_range=nil)
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