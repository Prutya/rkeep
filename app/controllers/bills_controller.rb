class BillsController < ApplicationController
  def index
    authorize! :index, Bill
    @bills = Bill.for_shift
  end
end
