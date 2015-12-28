class DashboardController < ApplicationController

  before_action :authenticate_user!

  def index

  end

private

  def secure_params
    params.require(:user).permit(:role)
  end

end