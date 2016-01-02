module Api
  module V1

    class ApiController < ApplicationController

      skip_before_filter :verify_authenticity_token

      respond_to :json

      before_filter :set_window

      before_filter :copy_search_params_to_session

    protected

      def cache_key(args)
        args.join('#')
      end

      def set_window
        @date_range = DashboardHelper.determine_window
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
          end_date = 1.day.ago.end_of_day
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