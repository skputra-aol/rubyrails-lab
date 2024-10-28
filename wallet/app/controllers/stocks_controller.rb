class StocksController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]
  load_and_authorize_resource # CanCan authorization helper
  before_action :set_stock, only: %i[show]

  def index
    @stocks = Stock.all
    render json: {status: {code: 200, message: "Success"}, data: @stocks}
  end

  def show
    @orders = @stock.orders
    @buy_orders = @orders.buy_transactions.order('price ASC')
    @sell_orders = @orders.sell_transactions.order('price DESC')
    render json: {status: {code: 200, message: "Success"}, data: { orders: @stocks, buy_orders: @buy_orders, sell_orders: @sell_orders }}
  end


  def create
    @stock = Stock.new(stock_params)
    if @stock.save
      render json: {status: {code: 200, message: "Stocks created successfully"}, data: @stock}
    else
      render json: {status: {code: 422, message: "Could not create stocks"}, errors: @stock.errors.full_messages}
    end
  end

  private

  def set_stock
    @stock = Stock.find(params[:id])
  end

  def stock_params
    params.require(:stock).permit(:ticker, :company_name, :quantity, :last_transaction_price)
  end
end
