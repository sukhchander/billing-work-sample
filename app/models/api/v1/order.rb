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
        window = date_range.present? ? date_range : DashboardHelper.determine_window
        query = Api::V1::Order.complete.where(end_at: window)
        DashboardHelper.format_currency(query.sum(:total))
      end

      def self.total_units(date_range=nil)
        window = date_range.present? ? date_range : DashboardHelper.determine_window
        query = Api::V1::Order.complete.where(end_at: window)
        DashboardHelper.format_unit(query.all.sum(:units))
      end

      def self.products(date_range=nil)
        window = date_range.present? ? date_range : DashboardHelper.determine_window
        query = Api::V1::Order.complete.where(end_at: window).includes(:product)
        query.joins(:product).select(:product_id)
      end

      def self.total_products(date_range=nil)
        query = self.total_products(date_range).count(:product_id)
        DashboardHelper.format_unit(query.count)
      end

      def self.customers(date_range=nil)
        window = date_range.present? ? date_range : DashboardHelper.determine_window
        query = Api::V1::Order.complete.where(end_at: window).includes(:user)
        query.joins(:user).group(:user_id)
      end

      def self.total_customers(date_range=nil)
        query = self.customers.count(:user_id)
        DashboardHelper.format_unit(query.count)
      end

      def self.aggregate(date_range=nil)
        window = date_range.present? ? date_range : DashboardHelper.determine_window
        query = Api::V1::Order.complete.where(end_at: window)
        filter = "COUNT(id) AS y_val, to_char(date(end_at), 'YYYY-MM') AS x_val, SUM(total) AS z_val"
        records = query.select(filter).group(:x_val).sort_by(&:x_val)

        {
          xAxis: records.collect(&:x_val),
          yAxis: records.collect(&:y_val),
          zAxis: records.collect(&:z_val)
        }
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