class UserShiftsController < ApplicationController
  def new
    @shift = Shift.preload({ user_shifts: :user }).find(params[:shift_id])
    @user_shift = UserShift.new({ shift: @shift })
    authorize! :create, @user_shift

    @users = User.all - @shift.users
  end

  def create
    shift = Shift.preload({ user_shifts: :user }).find_by_id(params[:shift_id])

    unless shift
      flash[:error] = 'Such shift does not exist.'
      return redirect_to shifts_url
    end

    user = User.find_by_id(params_create[:user_id])

    unless user
      flash[:error] = 'Such user does not exist.'
      return redirect_to new_shift_user_url(shift)
    end

    user_shift = UserShift.new({ shift: shift, user: user })
    authorize! :create, user_shift

    if user.at_shift? || shift.users.any? { |u| u.id == user.id }
      flash[:error] = 'User is already at shift.'
      return redirect_to new_user_shift_url(shift)
    end

    shift.user_shifts << user_shift

    flash[:success] = 'User successfully added.'
    redirect_to shift_url(shift)
  end

  protected

  def params_create
    params.require(:user_shift).permit(:user_id)
  end
end
