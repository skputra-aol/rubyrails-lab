class DashboardsController < ApplicationController
  def stockwallet
    @user_stocks_wallet = current_user.user_stocks
    render json: {status: {code: 200, message: "Success"}, data: @user_stocks}
  end
  def moneywallet
    @user_money_wallet = current_user.balance
    render json: {status: {code: 200, message: "Success"}, data: @user_money_wallet}
  end

  def myinfo
    render json: {status: {code: 200, message: 'Success'}, data: current_user}
  end

  def mytransaction
    @my_transaction = current_user.orders.all
    render json: {status: {code: 200, message: 'Success'}, data: @my_transaction}
  end

  def mytransactionrecord
    @my_transaction_rec = current_user.transaction_records.all
    render json: {status: {code: 200, message: 'Success'}, data: @my_transaction_rec}
  end

end
