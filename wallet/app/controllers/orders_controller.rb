class OrdersController < ApplicationController
  before_action :set_stock, only: %i[new create edit update destroy]
  before_action :set_order, only: %i[edit update destroy]

  def index
    @orders = Order.all
    render json: {status: {code: 200, message: "Success"}, data: @rrders}
  end

  def create
    @order = current_user.orders.build(order_params)
    @order[:stock_id] = @stock.id
    @order_quantity_copy = @order.quantity

    if @order.save
      render json: {status: {code: 200, message: "Order created successfully"}, data: @order}
    else
      render json: {status: {code: 422, message: "Could not create order"}, errors: @order.errors.full_messages}
    end
  end

  def update
    respond_to do |format|
      if @order.update(order_params)
        render json: {status: {code: 200, message: "Order changed successfully"}, data: @order}
      else
        render json: {status: {code: 422, message: "Could not create order"}, errors: @stock.errors.full_messages}
      end
    end
  end

  def destroy
    if @order.destroy
      render json: {status: {code: 200, message: "Order deleted successfully"}, data: @order}
    end
  end

  private

  def set_stock
    @stock = Stock.find(params[:stock_id])
  end

  def set_order
    @order = Order.find(params[:id])
  end

  def order_params
    params.require(:order).permit(:transaction_type, :price, :quantity, :stock_id)
  end
end
