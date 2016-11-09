class BillsController < ApplicationController
  def index
    authorize! :index, Bill
    @bills = Bill.for_shift
  end

  def new
    authorize! :create, Bill
    @bill = Bill.new
    @tables = Table.select('name, id')
  end

  def create
    authorize! :create, Bill
    Bill.create create_params
    redirect_to bills_url
  end

  def show
    authorize! :show, Bill
    @bill = Bill.find(params[:id])
  end

  protected

  def create_params
    params.require(:bill).permit(:table_id, :people_number, :discount)
  end

  def update_params
    params.require(:bill).permit(:table_id, :people_number, :discount, :time_cancel)
  end
end
