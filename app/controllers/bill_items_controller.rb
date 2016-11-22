class BillItemsController < ApplicationController
  def new
    @bill = Bill.includes(:shift).find(params[:bill_id])
    authorize! :update, @bill

    @goods = Good.all
    @bill_item = BillItem.new({ bill: @bill })
  end

  def create
    @bill = Bill.includes([ :shift, { bill_items: :good }]).find(params[:bill_id])
    authorize! :update, @bill

    @bill_item = @bill.bill_items.find_by(good_id: params_create[:good_id])

    if @bill_item.present?
      @bill_item.quantity += params_create[:quantity].to_i
    else
      @bill_item = BillItem.new(params_create)
      @bill_item.bill = @bill
    end

    unless @bill_item.save
      flash[:error] = 'Failed to add item'.
    else
      flash[:success] = 'Item added successfully.'
    end

    redirect_to shift_bill_url(@bill.shift, @bill)
  end

  def destroy
    @bill_item = BillItem.includes([{ bill: :shift }, :good]).find(params[:id])
    authorize! :update, @bill_item.bill

    bill_item.destroy!

    flash[:success] = 'Item removed successfully.'
    redirect_to shift_bill_url(@bill_item.bill.shift, @bill_item.bill)
  end

  protected

  def params_create
    params.require(:bill_item).permit(:quantity, :good_id)
  end
end
