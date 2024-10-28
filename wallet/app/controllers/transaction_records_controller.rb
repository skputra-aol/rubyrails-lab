class TransactionRecordsController < ApplicationController
  def index
    @transaction_records = current_user.transaction_records
    render json: {status: {code: 200, message: "Success"}, data: @transaction_records}
  end
end
