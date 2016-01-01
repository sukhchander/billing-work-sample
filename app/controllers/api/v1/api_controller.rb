module Api
  module V1

    class ApiController < ApplicationController

      skip_before_filter :verify_authenticity_token

      respond_to :json

    protected

      def cache_key(args)
        args.join('#')
      end

    end

  end
end