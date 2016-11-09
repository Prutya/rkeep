class BillsController < ApplicationController
  def index
    authorize! :index, Bill
    @bills = Bill.for_shift
  end

  def show
    authorize! :show, Bill
    @bill = Bill.includes([:table, { bill_items: :good }]).find(params[:id])
  end

  def new
    authorize! :create, Bill
    @bill = Bill.new
    @tables = Table.select('name, id')
  end

  def create
    authorize! :create, Bill

    bill = Bill.new(params_create)
    bill.user = current_user
    bill.save!
    flash[:success] = 'Bill created successfully.'

    redirect_to bills_url
  end

  def update
    authorize! :update, Bill
    @bill = Bill.find(params[:id])

    unless @bill.cancelled? || @bill.closed?
      @bill.cancel
      @bill.save!
      flash[:success] = 'Bill cancelled successfully.'
    else
      flash[:error] = 'This bill is already closed or cancelled.'
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
      flash[:error] = 'This bill is already closed.'
    end

    redirect_to bills_url
  end

  protected

  def params_create
    params.require(:bill).permit(:table_id, :people_number, :discount)
  end
end
