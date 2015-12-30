module Api
  module V1

    class Order < ActiveRecord::Base

      self.table_name = "orders"

      acts_as_paranoid

      belongs_to :user

      #has_many :line_items, -> { order(:created_at) }, inverse_of: :order

      #has_many :products

      belongs_to :product

      before_save :update_total

      after_initialize :set_initial_state, if: :new_record?

    private

      def set_initial_state
        self.state = :initial
      end

      def update_total
byebug
        self.total = self.product.unit_price * self.units
      end

    end

  end
end