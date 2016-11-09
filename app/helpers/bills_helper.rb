module BillsHelper
  def bootstrap_status(status)
    return :warning if status == :cancelled
    return :success if status == :closed
    :default
  end
end
