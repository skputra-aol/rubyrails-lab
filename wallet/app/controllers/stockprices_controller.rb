class StocksController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  load_and_authorize_resource # CanCan authorization helper
  before_action :set_stock, only: %i[show]

  def price
    @stocks = Stock.all
    render json: {status: {code: 200, message: "Success"}, data: @stocks}
  end

  def prices
    @stocks = Stock.all
    render json: {status: {code: 200, message: "Success"}, data: @stocks}
  end

  def price_all
    @stocks = Stock.all
    render json: {status: {code: 200, message: "Success"}, data: @stocks}
  end


  private

  def set_stock
    @stock = Stock.find(params[:id])
  end

  def stock_params
    params.require(:stock).permit(:ticker, :company_name, :quantity, :last_transaction_price)
  end
end
