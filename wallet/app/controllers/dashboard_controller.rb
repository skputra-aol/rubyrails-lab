class DashboardController < ApplicationController
  def index
    @user_stocks = current_user.user_stocks
    render json: {status: {code: 200, message: "Success"}, data: @user_stocks}
  end
end
