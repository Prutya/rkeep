class BillItemsController < ApplicationController
  def new
    authorize! :update, Bill
    bill = Bill.find(params[:bill_id])
    @bill_item = BillItem.new({ bill: bill })
  end
end
