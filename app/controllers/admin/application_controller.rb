module Admin

  class ApplicationController < Administrate::ApplicationController

    before_filter :authenticate_admin

    #before_action :authenticate_user!
    #after_action :verify_authorized

    def authenticate_admin
      # TODO Add authentication logic here.
    end

    # Override this value to specify the number of elements to display at a time
    # on index pages. Defaults to 20.
    # def records_per_page
    #   params[:per_page] || 20
    # end
  end

end