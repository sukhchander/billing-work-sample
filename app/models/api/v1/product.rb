module Api
  module V1

    class Product < ActiveRecord::Base

      self.table_name = :products

      acts_as_paranoid

      validates :sku, uniqueness: { conditions: -> { where(deleted_at: nil) } }, allow_blank: false

      has_many :orders

      def self.total_products
        DashboardHelper.format_unit(Product.count)
      end

      COLORS = {
        success: '#1F7BB6',
        primary: '#e25d5d',
        warning: '#EDCE8C',
        info: '#1F7BB6',
        danger: '#e25d5d',
        default: '#1F7BB6',
        alert: '#f5aca6',
        secondary: '#a6ca8a',
        tertiary: '#f2c779'
      }

      def self.breakdown(date_range=nil, display=false, xhr=false)
        self.breakdown_display(date_range, display, xhr)
      end

      def self.breakdown_data(date_range=nil)
        range = date_range.present? ? date_range : @date_range
        query = Api::V1::Order.complete.where(end_at: range).includes(:product)
        query.joins(:product).select(:product).select(:units).group(:product).sum(:units)
      end

      def self.breakdown_display(date_range=nil, display=false, xhr=false)
        records = self.breakdown_data(date_range)

        colors = COLORS.keys
        colors = COLORS.values if xhr

        result = []
        records.each_with_index do |record, index|
          product = record.first
          value = record.second
          result << {
            color: colors[index],
            value: value,
            highlight: colors.sample,
            label: product.display_name
          }
        end

        result
      end

      def performance_data(date_range=nil)
        window = date_range.present? ? date_range : DashboardHelper.determine_window
        query = Api::V1::Order.complete.where(end_at: window).where(product: self).includes(:product)
        filter = "product_id, COUNT(id) as y_val, to_char(date(end_at), 'YYYY-MM') AS x_val, SUM(total) AS amount"
        query.select(filter).group([:product_id, :x_val]).order(:product_id)
      end

      def performance_amount
        DashboardHelper.format_currency(self.performance_data.map(&:amount).sum)
      end

      def performance_units
        DashboardHelper.format_unit(self.performance_data.map(&:y_val).sum)
      end

      def self.performance(product_id=nil, date_range=nil, display=false, xhr=false)
        self.performance_display(product_id, date_range, display, xhr)
      end

      def self.performance_data(product_id=nil, date_range=nil)
        window = date_range.present? ? date_range : DashboardHelper.determine_window
        query = Api::V1::Order.complete.where(end_at: window).where(product_id: product_id).includes(:product)
        filter = "product_id, COUNT(id) as y_val, to_char(date(end_at), 'YYYY-MM') AS x_val, SUM(total) AS z_val"
        query.select(filter).group([:product_id, :x_val]).order(:product_id).sort_by(&:x_val)
      end

      def self.performance_display(product_id=nil, date_range=nil, display=false, xhr=false)
        records = self.performance_data(product_id, date_range)
        {
          xAxis: records.collect(&:x_val),
          yAxis: records.collect(&:y_val),
          zAxis: records.collect(&:z_val)
        }
      end

      def display_name
        self.sku.gsub('capsule:','')
      end

    end

  end
end