class SpendingsController < ApplicationController
  def new
    @shift = Shift.find(params[:shift_id])
    authorize! :update, @shift

    @spending = Spending.new({ shift: @shift })
  end

  def create
    @shift = Shift.find(params[:shift_id])
    authorize! :update, @shift

    @spending = Spending.new(params_create)
    @spending.shift = @shift

    unless @spending.valid?
      flash[:error] = @spending.errors.empty? ? "Error" : @spending.errors.full_messages.to_sentence
      return redirect_to new_shift_spending_url
    end

    @spending.save!

    flash[:success] = 'Spending created successfully.'
    redirect_to shift_url(@shift)
  end

  def destroy
    @spending = Spending.includes(:shift).find(params[:id])
    authorize! :update, @spending.shift

    @spending.cancel
    @spending.save!

    flash[:success] = 'Spending cancelled successfully.'

    redirect_to shift_url(@spending.shift)
  end

  protected

  def params_create
    params.require(:spending).permit(:name, :total)
  end
end
