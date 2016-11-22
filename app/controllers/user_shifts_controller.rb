class UserShiftsController < ApplicationController
  def new
    @shift = Shift.preload({ user_shifts: :user }).find(params[:shift_id])
    authorize! :update, @shift

    @user_shift = UserShift.new({ shift: @shift })
    @users = User.all - @shift.users
  end

  def create
    @shift = Shift.preload({ user_shifts: :user }).find(params[:shift_id])
    @user = User.preload({ user_shifts: :shift }).find(params_create[:user_id])
    authorize! :update, @shift

    UserShift.create({ shift: @shift, user: @user })

    flash[:success] = 'Employee added successfully'
    redirect_to shift_url(@shift)
  end

  protected

  def params_create
    params.require(:user_shift).permit(:user_id)
  end
end
