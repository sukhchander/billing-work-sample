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