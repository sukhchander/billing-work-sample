module Api
  module V1

    class ApiController < ApplicationController

      skip_before_filter :verify_authenticity_token

      respond_to :json

      before_filter :set_window

    protected

      def cache_key(args)
        args.join('#')
      end

      def set_window
        @date_range = DashboardHelper.determine_window
        if params[:start_date].present? && params[:end_date].present?
          start_date = Time.at(params[:start_date].to_i/1000).beginning_of_day
          end_date = Time.at(params[:end_date].to_i/1000).end_of_day
          @date_range = start_date..end_date
        end
      end

    end

  end
end