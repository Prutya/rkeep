class BillItemsController < ApplicationController
  def new
    authorize! :update, Bill
    @bill = Bill.includes(:shift).find(params[:bill_id])
    @goods = Good.all
    @bill_item = BillItem.new({ bill: @bill })
  end

  def create
    @bill = Bill.includes([ :shift, { bill_items: :good }]).find(params[:bill_id])
    authorize! :update, @bill

    if @bill.shift.closed?
      flash[:error] = 'This shift is closed.'

      return redirect_to shift_bill_url(@bill.shift, @bill)
    end

    if @bill.closed? || @bill.cancelled?
      flash[:error] = 'This bill is closed or cancelled.'

      return redirect_to shift_bill_url(@bill.shift, @bill)
    end

    create_or_add(params_create)
    flash[:success] = 'Item added successfully.'

    redirect_to shift_bill_url(@bill.shift, @bill)
  end

  def destroy
    @bill_item = BillItem.includes([{ bill: :shift }, :good]).find(params[:id])
    authorize! :update, @bill_item.bill

    if @bill_item.bill.closed? || @bill_item.bill.cancelled?
      flash[:error] = 'This bill is closed or cancelled.'

      return redirect_to shift_bill_url(@bill_item.bill.shift, @bill_item.bill)
    end

    @bill_item.destroy!
    flash[:success] = 'Item removed successfully.'

    redirect_to shift_bill_url(@bill_item.bill.shift, @bill_item.bill)
  end

  protected

  def params_create
    params.require(:bill_item).permit(:quantity, :good_id)
  end

  def create_or_add(bill_item, bill = @bill)
    existing_item = bill.bill_items.find_by(good_id: params_create[:good_id])

    if (existing_item.present?)
      existing_item.quantity += params_create[:quantity].to_i
      existing_item.save!
    else
      bill.bill_items << BillItem.new(params_create)
    end

    bill.save!
  end
end
