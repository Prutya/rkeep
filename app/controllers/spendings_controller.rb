class SpendingsController < ApplicationController
  def index
    authorize! :index, Spending
    @spendings = Spending.for_shift(Time.zone.now).includes(:user)
  end

  def new
    authorize! :create, Spending
    @spending = Spending.new
  end

  def create
    authorize! :create, Spending
  end

  def destroy
    authorize! :destroy, Spending
  end
end
