class BillsController < ApplicationController
  def show
    @bill = Bill.includes([:table, :discount, :shift, { bill_items: :good }]).find(params[:id])
    authorize! :show, @bill.shift
  end

  def new
    @shift = Shift.find(params[:shift_id])
    authorize! :update, @shift

    @bill = Bill.new({shift: @shift})
    @tables = Table.select('name, id')
    @discounts = Discount.select('value, id')
  end

  def create
    @shift = Shift.find(params[:shift_id])
    @table = Table.find(params_create[:table_id])
    @discount = Discount.find(params_create[:discount_id])
    authorize! :update, @shift

    debugger

    @bill = Bill.create({
      shift: @shift,
      table: @table,
      discount: @discount,
      relative_id: @shift.next_bill_number,
      people_number: params_create[:people_number] })

    flash[:success] = 'Bill created successfully.'
    redirect_to shift_bill_url(@shift, @bill)
  end

  def edit
    @bill = Bill.includes([ :shift, :table, :discount ]).find(params[:id])
    authorize! :update, @bill

    @tables = Table.select('name, id')
    @discounts = Discount.select('value, id')
  end

  def update
    @bill = Bill.includes(:shift).find(params[:id])
    @table = Table.find(params_update[:table_id])
    @discount = Discount.find(params_update[:discount_id])
    authorize! :update, @bill

    @bill.update_attributes(params_update)

    flash[:success] = 'Bill updated successfully.'
    redirect_to shift_bill_url(@bill.shift, @bill)
  end

  def cancel
    @bill = Bill.includes(:shift).find(params[:id])
    authorize! :update, @bill

    @bill.cancel
    @bill.save!

    flash[:success] = 'Bill cancelled successfully.'
    redirect_to shift_url(@bill.shift)
  end

  def destroy
    @bill = Bill.includes(:shift).find(params[:id])
    authorize! :update, @bill

    @bill.close
    @bill.save!

    flash[:success] = 'Bill closed successfully.'
    redirect_to shift_url(@bill.shift)
  end

  protected

  def params_create
    params.require(:bill).permit(:table_id, :discount_id, :people_number)
  end

  def params_update
    params.require(:bill).permit(:table_id, :discount_id, :people_number)
  end
end
