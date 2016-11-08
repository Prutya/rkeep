module BillsHelper
  def bootstrap_status(status)
    return :warning if status == :cancel
    return :success if status == :closed
    :default
  end
end
