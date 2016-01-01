class DashboardController < ApplicationController

  before_action :authenticate_user!

  def index
  end

  def show
    type = params[:type]
    render type.to_sym if type.present?
  end

private

  def secure_params
    params.require(:user).permit(:role)
  end

end