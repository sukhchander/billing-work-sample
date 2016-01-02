module Api
  module V1

    class DataController < Api::V1::ApiController

      CACHE_TIME = 10.minutes

      def show
        type = params[:type]
        data = send(type.to_sym) if type.present?
        respond_with data
      end

    private

      def aggregate
        Rails.cache.fetch(cache_key([:aggregate, @date_range]), expires_in: CACHE_TIME) do
          Api::V1::Order.aggregate(@date_range)
        end
      end

      def breakdown_product

        Rails.cache.fetch(cache_key([:breakdown_product, @date_range]), expires_in: CACHE_TIME) do
          Api::V1::Product.breakdown(@date_range, true, true)
        end

      end

      def breakdown_customer

        Rails.cache.fetch(cache_key([:breakdown_customer, @date_range]), expires_in: CACHE_TIME) do
          Api::V1::User.breakdown(@date_range, true)
        end

      end

    end

  end
end