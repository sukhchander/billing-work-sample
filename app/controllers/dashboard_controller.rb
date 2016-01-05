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
    if params[:start_date].present? && params[:end_date].present?
      start_date = Date.parse(params[:start_date]).beginning_of_day
      end_date = Date.parse(params[:end_date]).end_of_day
      @date_range = start_date..end_date
    end
  end

end