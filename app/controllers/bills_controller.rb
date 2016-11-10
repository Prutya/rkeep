class BillsController < ApplicationController
  def index
    authorize! :index, Bill
    @bills = Bill.for_shift
  end

  def show
    authorize! :show, Bill
    @bill = Bill.includes([:table, :discount, :user, { bill_items: :good }]).find(params[:id])
  end

  def new
    authorize! :create, Bill
    @bill = Bill.new

    @tables = Table.select('name, id')
    @discounts = Discount.select('value, id')
  end

  def create
    authorize! :create, Bill

    unless Table.exists?(params_create[:table_id])
      flash[:error] = 'Such table does not exist.'
      return redirect_to bill_url(@bill)
    end

    unless Discount.exists?(params_create[:discount_id])
      flash[:error] = 'Such discount does not exist.'
      return redirect_to bill_url(@bill)
    end

    bill = Bill.new(params_create)
    bill.user = current_user
    bill.save!
    flash[:success] = 'Bill created successfully.'

    redirect_to bills_url
  end

  def edit
    authorize! :update, Bill
    @bill = Bill.find(params[:id])

    @tables = Table.select('name, id')
    @discounts = Discount.select('value, id')
  end

  def update
    authorize! :update, Bill
    @bill = Bill.find(params[:id])

    unless Table.exists?(params_create[:table_id])
      flash[:error] = 'Such table does not exist.'
      return redirect_to bill_url(@bill)
    end

    unless Discount.exists?(params_create[:discount_id])
      flash[:error] = 'Such discount does not exist.'
      return redirect_to bill_url(@bill)
    end

    unless @bill.cancelled? || @bill.closed?
      @bill.update_attributes(params_update)
      flash[:success] = 'Bill updated successfully.'
    else
      flash[:error] = 'This bill is closed or cancelled.'
    end

    redirect_to bill_url(@bill)
  end

  def cancel
    authorize! :update, Bill
    @bill = Bill.find(params[:id])

    unless @bill.cancelled? || @bill.closed?
      @bill.cancel
      @bill.save!
      flash[:success] = 'Bill cancelled successfully.'
    else
      flash[:error] = 'This bill is closed or cancelled.'
    end

    redirect_to bills_url
  end

  def destroy
    authorize! :destroy, Bill
    @bill = Bill.find(params[:id])

    unless @bill.closed?
      @bill.close
      @bill.save!
      flash[:success] = 'Bill closed successfully.'
    else
      flash[:error] = 'This bill is closed.'
    end

    redirect_to bills_url
  end

  protected

  def params_create
    params.require(:bill).permit(:table_id, :people_number, :discount_id)
  end

  def params_update
    params.require(:bill).permit(:table_id, :people_number, :discount_id)
  end
end
