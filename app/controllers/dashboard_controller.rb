class DashboardController < ApplicationController

  before_action :authenticate_user!
  after_action :verify_authorized

  def index
    authorize User
  end

private

  def secure_params
    params.require(:user).permit(:role)
  end

end