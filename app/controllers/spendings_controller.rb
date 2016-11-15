class SpendingsController < ApplicationController
  def new
    authorize! :create, Spending
    @shift = Shift.find(params[:shift_id])
    @spending = Spending.new({ shift: @shift })
  end

  def create
    shift = Shift.find_by_id(params[:shift_id])

    unless shift
      flash[:error] = 'Such shift does not exist.'
      return redirect_to shifts_url
    end

    spending = Spending.new(params_create)
    spending.shift = shift

    authorize! :create, spending

    if spending.save
      flash[:success] = 'Spending created successfully.'
      return redirect_to shift_url(shift)
    end

    flash[:error] = spending.errors.empty? ? "Error" : spending.errors.full_messages.to_sentence
    redirect_to new_shift_spending_url
  end

  def destroy
    spending = Spending.find_by_id(params[:id])

    unless spending
      flash[:error] = 'Such spending does not exist.'
      return redirect_to shifts_url
    end

    authorize! :destroy, spending

    spending.cancel
    spending.save!

    flash[:success] = 'Spending cancelled successfully.'

    redirect_to shift_url(spending.shift)
  end

  protected

  def params_create
    params.require(:spending).permit(:name, :total)
  end
end
