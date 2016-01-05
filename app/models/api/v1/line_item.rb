module Api
  module V1

    class LineItem < ActiveRecord::Base

      self.table_name = "line_items"

      acts_as_paranoid

      belongs_to :order, class_name: "Api::V1::Billing::Order", touch: true

      belongs_to :product

      validates :units, numericality: { only_integer: true, greater_than: 0}

      validates :price, numericality: true

      def amount
        price * units
      end

    end

  end
end