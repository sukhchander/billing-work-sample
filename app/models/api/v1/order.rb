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
        window = date_range.present? ? date_range : determine_window
        query = Api::V1::Order.complete.where(end_at: window)
        ActiveSupport::NumberHelper::number_to_currency(query.sum(:total))
      end

      def self.total_hours(date_range=nil)
        window = date_range.present? ? date_range : determine_window
        query = Api::V1::Order.complete.where(end_at: window)
        ActiveSupport::NumberHelper::number_to_delimited(query.all.sum(:units))
      end

      def self.total_products(date_range=nil)
        window = date_range.present? ? date_range : determine_window
        query = Api::V1::Order.complete.where(end_at: window)
        query.joins(:product).select(:product)
        ActiveSupport::NumberHelper::number_to_delimited(Product.count)
      end

      def self.total_customers(date_range=nil)
        window = date_range.present? ? date_range : determine_window
        query = Api::V1::Order.complete.where(end_at: window).joins(:user).group(:user_id).count(:user_id)
        ActiveSupport::NumberHelper::number_to_delimited(query.count)
      end

      def self.aggregate(date_range=nil)
        window = date_range.present? ? date_range : determine_window
        query = Api::V1::Order.complete.where(end_at: window)
        filter = "COUNT(id) AS y_val, to_char(date(end_at), 'MM/YYYY') AS x_val, SUM(total) AS z_val"
        records = query.select(filter).group(:x_val).sort_by(&:x_val)

        {
          xAxis: records.collect(&:x_val),
          yAxis: records.collect(&:y_val),
          zAxis: records.collect(&:z_val)
        }
      end

    private

      def self.determine_window
        start_date = 6.months.ago.beginning_of_day
        end_date = 1.day.ago.end_of_day
        start_date..end_date
      end

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