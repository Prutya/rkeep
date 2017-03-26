class Api::V1::BillsController < Api::V1::ApiController
  authorize_resource only: [:index, :show]

  def index
    @bills = Bill.all
  end

  def show
    @bill = Bill
      .includes(:discount, bill_items: [ :good ])
      .order('bill_items.created_at ASC')
      .find(params[:id])
  end
end
