class DashboardController < ApplicationController

  before_action :authenticate_user!

  before_filter :set_window

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

  def set_window
    @date_range = DashboardHelper.determine_window
  end

end