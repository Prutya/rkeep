class BillsController < ApplicationController
  def index
    @shift = Shift.includes([:table, :discount, { user_shifts: :user }]).find(params[:shift_id])
    authorize! :index, @shift
  end

  def show
    @bill = Bill.includes([:table, :discount, :shift, { bill_items: :good }]).find(params[:id])
    authorize! :show, @bill
  end

  def new
    authorize! :create, Bill
    @shift = Shift.find(params[:shift_id])
    @bill = Bill.new({shift_id: @shift.id})

    @tables = Table.select('name, id')
    @discounts = Discount.select('value, id')
  end

  def create
    shift = Shift.find(params[:shift_id])
    authorize! :create, Bill

    bill = Bill.new(params_create)

    unless Table.exists?(params_create[:table_id])
      flash[:error] = 'Such table does not exist.'
      return redirect_to shift_bills_url(shift, bill)
    end

    unless Discount.exists?(params_create[:discount_id])
      flash[:error] = 'Such discount does not exist.'
      return redirect_to shift_bills_url(shift, bill)
    end

    shift.bills << bill
    flash[:success] = 'Bill created successfully.'

    redirect_to shift_bill_url(shift, bill)
  end

  def edit
    @bill = Bill.includes(:shift).find(params[:id])
    authorize! :update, @bill

    @tables = Table.select('name, id')
    @discounts = Discount.select('value, id')
  end

  def update
    bill = Bill.includes(:shift).find(params[:id])
    authorize! :update, bill

    unless Table.exists?(params_create[:table_id])
      flash[:error] = 'Such table does not exist.'
      return redirect_to shift_bill_url(bill.shift, bill)
    end

    unless Discount.exists?(params_create[:discount_id])
      flash[:error] = 'Such discount does not exist.'
      return redirect_to shift_bill_url(bill.shift, bill)
    end

    unless bill.cancelled? || bill.closed?
      bill.update_attributes(params_update)
      flash[:success] = 'Bill updated successfully.'
    else
      flash[:error] = 'This bill is closed or cancelled.'
    end

    redirect_to shift_bill_url(bill.shift, bill)
  end

  def cancel
    authorize! :update, Bill
    bill = Bill.includes(:shift).find(params[:id])

    unless bill.cancelled? || bill.closed?
      bill.cancel
      bill.save!
      flash[:success] = 'Bill cancelled successfully.'
    else
      flash[:error] = 'This bill is closed or cancelled.'
    end

    redirect_to shift_bill_url(bill.shift, bill)
  end

  def destroy
    authorize! :destroy, Bill
    bill = Bill.includes(:shift).find(params[:id])

    unless bill.closed?
      bill.close
      bill.save!
      flash[:success] = 'Bill closed successfully.'
    else
      flash[:error] = 'This bill is closed.'
    end

    redirect_to shift_bill_url(bill.shift, bill)
  end

  protected

  def params_create
    params.require(:bill).permit(:shift_id, :table_id, :discount_id, :people_number,)
  end

  def params_update
    params.require(:bill).permit(:table_id, :people_number, :discount_id)
  end
end
