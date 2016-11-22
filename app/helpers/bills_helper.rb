module BillsHelper
  def bill_status(status)
    return :warning if status == :cancelled
    return :success if status == :closed
    :neutral
  end
end
