module Api
  module V1

    class DataController < Api::V1::ApiController

      before_filter :copy_search_params_to_session

      CACHE_TIME = 10.minutes

      def show

        #type
        # :all, :product, :customer

        chart = params[:type]

        data = send(chart.to_sym)

        respond_with data

      end

    private

      def all

        records = Rails.cache.fetch(cache_key([:data_all_records, @date_range]), expires_in: CACHE_TIME) do
          query = Api::V1::Order.complete.where(end_at: @date_range)
          selectors = "COUNT(id) AS y_val, to_char(date(end_at), 'MM/YYYY') AS x_val, SUM(total) AS z_val"
          query.select(selectors).group(:x_val)
        end.sort_by(&:x_val)

        result = Rails.cache.fetch(cache_key([:data_all_result, @date_range]), expires_in: CACHE_TIME) do
          {
            xAxis: records.collect(&:x_val),
            yAxis: records.collect(&:y_val).map(&:to_i),
            zAxis: records.collect(&:z_val).map(&:to_i),
          }
        end

      end
=begin
{
    value: 300,
    color: "#1ABC9C",
    highlight: "#1ABC9C",
    label: "Chrome"
}, {
    value: 50,
    color: "#556B8D",
    highlight: "#556B8D",
    label: "IE"
}, {
    value: 100,
    color: "#EDCE8C",
    highlight: "#EDCE8C",
    label: "Safari"
}, {
    value: 40,
    color: "#CED1D3",
    highlight: "#1F7BB6",
    label: "Other"
}, {
    value: 120,
    color: "#1F7BB6",
    highlight: "#1F7BB6",
    label: "Firefox"
}
=end

      def product_breakdown

        records = Rails.cache.fetch(cache_key([:data_product_records, @date_range]), expires_in: CACHE_TIME) do
          query = Api::V1::Order.complete.where(end_at: @date_range)
          query.joins(:product).select(:product).select(:units).group(:product).sum(:units)
        end

        result = Rails.cache.fetch(cache_key([:data_product_breakdown_result, @date_range]), expires_in: CACHE_TIME) do
          records.collect do |record|
            {
              value: record.second,
              color: "#CED1D3",
              highlight: "#1F7BB6",
              label: record.first.sku.gsub('capsule:','')
            }
          end
        end

      end

      def foo

        #redirect_to sellect.dashboard_data_dashboard_region_path(params)

        result = Rails.cache.fetch(cache_key([:chart, @date_range, @region]), expires_in: CACHE_TIME) do
          orders = Sellect::Order.complete.where(zone_id: @zone).where(updated_at: @date_range)

          orders_refunded = orders.where(substate: :refund_processed)

          orders_return_auths_approved = orders_refunded.map(&:return_authorizations).map(&:approved).flatten

          orders_refunds_processed = orders_return_auths_approved.map(&:refund).map(&:amount)

          @orders_refunded_total = orders_refunds_processed.sum

          orders_by_date = 'DATE_FORMAT(updated_at, "%Y-%m-%d") AS date, COUNT(id) AS num_orders, SUM(total) as order_total'

          orders.select(orders_by_date).group(:date)
        end

        orders_series = Rails.cache.fetch(cache_key(['chart::series', @date_range, @region]), expires_in: CACHE_TIME) do
          result.collect do |order|
            {
              x: order.date,
              y: order.num_orders.to_i,
              total: order.order_total - @orders_refunded_total,
              region: @region
            }
          end
        end

        respond_to do |format|
          format.json {
            render json: [{className: ".orders", data: orders_series }]
          }
        end
      end

      def aggregate
        result = Rails.cache.fetch(cache_key([:aggregate, @date_range, @region]), expires_in: CACHE_TIME) do
          orders = Sellect::Order.complete.where(zone_id: @zone).where(updated_at: @date_range)

          orders_total = orders.sum(:total)

          items_sold = Sellect::LineItem.where(order_id: orders).sum(:quantity)

          items_total = orders.sum(:item_total)

          orders_tax_total = orders.map(&:adjustments).map(&:tax).flatten.map(&:amount).sum

          orders_shipping_total = orders.map(&:adjustments).map(&:shipping).flatten.map(&:amount).sum

          orders_refunded = orders.where(substate: :refund_processed)

          orders_return_auths_approved = orders_refunded.map(&:return_authorizations).map(&:approved).flatten

          orders_refunds_processed = orders_return_auths_approved.map(&:refund).map(&:amount)

          orders_refunded_total = orders_refunds_processed.sum

          [
            orders.size,
            items_sold,
            format_amount(items_total, @currency),
            format_amount(orders_tax_total, @currency),
            format_amount(orders_shipping_total, @currency),
            orders_refunded.size,
            format_amount(orders_refunded_total, @currency),
            format_amount(orders_total - orders_refunded_total, @currency)
          ]
        end

        respond_to do |format|
          format.json {
            render json: result
          }
        end
      end

    private

      def orders_for(zone)
        orders = Sellect::Order.complete.where(zone_id: zone).where(updated_at: @date_range)

        orders_refunded = orders.where(substate: :refund_processed)

        orders_return_auths_approved = orders_refunded.map(&:return_authorizations).map(&:approved).flatten

        orders_refunds_processed = orders_return_auths_approved.map(&:refund).map(&:amount)

        orders_refunded_total = orders_refunds_processed.sum

        Rails.cache.fetch([:dashboard, zone.name, @date_range].join('#'), expires_in: 10.minutes) do
          {
            recent: orders.last(7),
            total: orders.sum(:total) - orders_refunded_total,
            avg: (orders.sum(:total) - orders_refunded_total) / orders.size
          }
        end
      end

      def copy_search_params_to_session
        if params[:chart_form].present?
          session[:chart_form] = HashWithIndifferentAccess.new(params[:chart_form])
          @chart_form = session[:chart_form]
        elsif session[:chart_form].present?
          @chart_form = HashWithIndifferentAccess.new(session[:chart_form])
        else
          @chart_form = {}
          start_date = 6.months.ago.beginning_of_day
          @chart_form[:start_date] = start_date.strftime("%b %d, %Y")
          end_date = Date.today.end_of_day
          @chart_form[:end_date] = end_date.strftime("%b %d, %Y")
        end

        if @chart_form[:start_date].present? && @chart_form[:end_date].present?
          start_date = Date.parse(@chart_form[:start_date].to_time.to_s).beginning_of_day
          end_date = Date.parse(@chart_form[:end_date].to_time.to_s).end_of_day
          @date_range = start_date..end_date
        end
      end

    end

  end
end