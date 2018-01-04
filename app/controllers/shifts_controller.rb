class ShiftsController < ApplicationController
  def index
    authorize! :index, Shift
    if current_user.admin?
      @shifts = Shift.paginate(page: params[:page], per_page: 10).includes([ :bills, :spendings ])
    else
      @shifts = current_user.shifts.paginate(page: params[:page], per_page: 10).includes([ :bills, :spendings ])
    end
  end

  def create
    @shift = Shift.new({ opened_at: Time.zone.now })
    authorize! :create, Shift

    @shift.save
    @shift.users << current_user

    notify_shift_started

    flash[:success] = 'Shift created successfully.'
    redirect_to shift_url(@shift)
  end

  def show
    @shift = Shift.includes([ :spendings, { bills: [ :table, :discount, { bill_items: :good } ] } ]).find(params[:id])
    authorize! :show, @shift
  end

  def destroy
    @shift = Shift.find(params[:id])
    authorize! :destroy, @shift

    if @shift.has_open_bills?
      flash[:error] = 'Shift has open bills.'
      return redirect_to shift_url(@shift)
    end

    @shift.close
    @shift.save!

    notify_shift_ended

    flash[:success] = 'Shift closed successfully.'
    redirect_to shifts_url
  end

  private

  def notify_shift_started
    employee = @shift.users.first

    find_admins.each do |admin|
      Telegram::Client.send_message title: 'Shift started', message: <<~MSG
        Hey, #{admin.first_name || 'Admin'}.
        A shift has just started.
        Started at: #{@shift.opened_at}
        Started by: #{employee.name}
      MSG
    end
  end

  def notify_shift_ended
    find_admins.each do |admin|
      Telegram::Client.send_message title: 'Shift ended', message: <<~MSG
        Hey,
        A shift has just ended.
        Closed at: #{@shift.closed_at}
        Closed by: #{current_user.name}
      MSG
    end
  end

  def find_admins
    User.joins(assignments: :role).where(roles: { name: :admin })
  end
end
