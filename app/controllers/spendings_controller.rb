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
    @spending = Spending.new(params_create)
    @spending.user = current_user

    if @spending.save
      flash[:success] = 'Spending created successfully.'
      return redirect_to spendings_url
    end

    flash[:error] = @spending.errors.empty? ? "Error" : @spending.errors.full_messages.to_sentence
    redirect_to new_spending_url
  end

  def destroy
    authorize! :destroy, Spending
    @spending = Spending.find(params[:id])

    @spending.cancel
    @spending.save!

    flash[:success] = 'Spending cancelled successfully.'

    redirect_to spendings_url
  end

  protected

  def params_create
    params.require(:spending).permit(:name, :total)
  end
end
