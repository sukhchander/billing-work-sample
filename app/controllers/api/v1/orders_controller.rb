module Api
  module V1

    class OrdersController < Api::V1::ApiController

      before_filter :load_product
      before_filter :load_user
      before_filter :load_order

      def update
        if @order.present?
          @order.start_at = order_params.start_at
          @order.units = order_params.units
          @order.state = :update if @order.units > 1
          @order.save
        end

        respond_with @order
      end

      def destroy
        if @order.present?
          @order.end_at = order_params.end_at
          @order.state = :end
          @order.save
        end
        respond_with @order
      end

    private

      def order_params
        hash = {
          account_id: nil,
          sku: nil,
          units: nil,
          identifier: nil,
          group_sku: nil,
          group_identifier: nil,
          start_at: nil,
          end_at: nil
        }
        hash.keys.each { |key| hash[key] = params[key] if params.has_key? key }
        OpenStruct.new(hash)
      end

      def load_product
        @product = Product.where(sku: order_params.sku).first
      end

      def load_user
        @user = User.find(order_params.account_id)
      end

      def load_order
        @order = Order.where({
          user_id: @user.id,
          product_id: @product.id,
          identifier: order_params.identifier,
          group_sku: order_params.group_sku,
          group_identifier: order_params.group_identifier
        }).first_or_create
      end

    end

  end
end