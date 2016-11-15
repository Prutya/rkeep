module ShiftsHelper
  def shift_bootstrap_status(status)
    return :success if status == :closed
    :default
  end
end
