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

      COLORS = [:success, :primary, :warning, :info, :danger, :default, :alert, :secondary, :tertiary]

      def self.usage_breakdown(date_range=nil)
        window = date_range.present? ? date_range : determine_window
        query = Api::V1::Order.complete.where(end_at: window)
        query.joins(:product).select(:product).select(:units).group(:product).sum(:units)
      end

      def self.usage_breakdown_display(date_range=nil, hex=false)

        records = self.usage_breakdown(date_range)

        colors = COLORS
        colors = %w(#1F7BB6 #e25d5d #EDCE8C #1F7BB6 #e25d5d #1F7BB6 #f5aca6 #a6ca8a #f2c779) if hex

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

      def display_name
        self.sku.gsub('capsule:','')
      end

    private

      def self.determine_window
        start_date = 6.months.ago.beginning_of_day
        end_date = 1.day.ago.end_of_day
        start_date..end_date
      end

      def self.cache_key(args)
        args.join('#')
      end

    end

  end
end