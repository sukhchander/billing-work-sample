require_dependency "admin/application_controller"

module Admin
  class SessionsController < ApplicationController
    include Godmin::Authentication::SessionsController

    def create
      @admin_user = admin_user_class.find_by_login(admin_user_login)

      if @admin_user && @admin_user.authenticate(admin_user_params[:password])
        session[:admin_user_id] = @admin_user.id
        redirect_to root_path, notice: t("godmin.sessions.signed_in")
      else
        redirect_to new_session_path, alert: t("godmin.sessions.failed_sign_in")
      end
    end

  end
end