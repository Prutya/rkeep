module ShiftsHelper
  def shift_status(status)
    return :success if status == :closed
    :neutral
  end
end
