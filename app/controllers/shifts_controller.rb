class ShiftsController < ApplicationController
  def index
    authorize! :index, Shift
    @shifts = Shift.preload([ :bills, :spendings ])
  end

  def create
    authorize! :create, Shift
    @shift = Shift.create({ opened_at: Time.zone.now })
    @shift.users << current_user

    flash[:success] = 'Shift successfully created.'
    redirect_to shift_url(@shift)
  end

  def show
    @shift = Shift.includes([ :spendings, { bills: [ :table, :discount, { bill_items: :good } ] } ]).find(params[:id])
    authorize! :show, Shift
  end
end
