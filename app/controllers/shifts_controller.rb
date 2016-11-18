class ShiftsController < ApplicationController
  def index
    authorize! :index, Shift
    if current_user.admin?
      @shifts = Shift.paginate(page: params[:page], per_page: 20).includes([ :bills, :spendings ])
    else
      @shifts = current_user.shifts.paginate(page: params[:page], per_page: 20).includes([ :bills, :spendings ])
    end
  end

  def create
    authorize! :create, Shift
    shift = Shift.create({ opened_at: Time.zone.now })
    shift.users << current_user

    flash[:success] = 'Shift created successfully.'

    redirect_to shift_url(shift)
  end

  def show
    @shift = Shift.includes([ :spendings, { bills: [ :table, :discount, { bill_items: :good } ] } ]).find(params[:id])
    authorize! :show, @shift
  end

  def destroy
    shift = Shift.find(params[:id])
    authorize! :destroy, shift

    unless shift.closed?
      shift.close
      shift.save!

      flash[:success] = 'Shift closed successfully.'
    else
      flash[:error] = 'Shift is already closed.'
    end

    redirect_to shifts_url
  end
end
