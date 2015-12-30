module Api
  module V1

    class OrdersController < Api::V1::ApiController

      before_filter :load_product
      before_filter :load_user
      before_filter :load_order

      def update
        if @order.present?
          @order.starts_at = order_params.starts_at
          @order.units = order_params.units
          @order.state = :updated
          @order.save
        end

        respond_with @order
      end

      def destroy
        if @order.present?
          @order.ends_at = order_params.ends_at
          @order.state = :completed
          @order.save
        end

        respond_with @order
      end

    private

      def order_params
        hash = {
          account_id: nil,
          sku: nil,
          identifier: nil,
          group_sku: nil,
          group_identifier: nil,
          start_at: nil,
          units: nil
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

=begin

1.upto(500) {|i| u=User.new({email: FFaker::Internet.email, password: :foobarbaz}); u.confirm; u.save}

params = {"account_id":125,"sku":"capsule:mongodb","identifier":"capsule:53cde195f1f9772fdf000005","group_sku":"deployment:mongodb","group_identifier":"deployment:3765","start_at":"2015-10-01T22:35:24Z","units":1}

          hash = {
            account_id: nil,
            sku: nil,
            identifier: nil,
            group_sku: nil,
            group_identifier: nil,
            start_at: nil,
            units: nil
          }
          hash.keys.each { |key| hash[key] = params[key] if params.has_key? key }
          order_params = OpenStruct.new(hash)

          @product = Api::V1::Product.where(sku: order_params.sku).first

          order = Api::V1::Order.where({
            units: order_params.units,
            product_id: @product.id,
            user_id: order_params.account_id,
            identifier: order_params.identifier,
            group_sku: order_params.group_sku,
            group_identifier: order_params.group_identifier
          }).first_or_create

          order = Api::V1::Order.where({
            units: order_params.units,
            product_id: @product.id,
            user_id: order_params.account_id,
            identifier: order_params.identifier,
            group_sku: :foobar,
            group_identifier: order_params.group_identifier
          }).first_or_create


params = {"account_id":125,"sku":"capsule:mongodb","identifier":"capsule:53cde195f1f9772fdf000005","group_sku":"deployment:mongodb","group_identifier":"deployment:3765","start_at":"2015-10-03T11:34:37Z","units":5}
=end