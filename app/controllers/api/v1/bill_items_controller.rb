class Api::V1::BillItemsController < Api::V1::ApiController
  def create
    bill_item_params = create_params

    @bill = Bill.includes(:discount).find_by(id: params[:bill_id])
    authorize! :update, @bill

    @bill_item = @bill.bill_items
      .where(time_cancel: nil)
      .includes(:good)
      .find_by(good_id: bill_item_params[:good_id])

    if @bill_item.present?
      @bill_item.quantity += bill_item_params[:quantity].to_i
    else
      @good = Good.find_by(id: bill_item_params[:good_id])
      @bill_item = BillItem.new(create_params)
      @bill_item.good = @good
      @bill_item.bill = @bill
    end

    @bill_item.save!
  end

  def destroy
    @bill = Bill.includes(:discount).find_by(id: params[:bill_id])
    authorize! :update, @bill

    @bill_item = @bill.bill_items.find_by(id: params[:id])

    @bill_item.cancel
    @bill_item.save!
  end

  protected

  def create_params
    params.require(:bill_item).permit(:good_id, :quantity)
  end
end
