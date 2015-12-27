module Api
  module V1
    module Billing

      class Order < ActiveRecord::Base

        self.table_name = "orders"

        acts_as_paranoid

        belongs_to :user

        has_many :line_items, -> { order(:created_at) }, inverse_of: :order

        has_many :products

        def amount
          line_items.inject(0.0) { |sum, li| sum + li.amount }
        end

        def quantity
          line_items.sum(:quantity)
        end

      private

        def ensure_line_items_present
          return false unless line_items.present?
        end

      end

    end
  end
end