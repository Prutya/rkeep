json.status @status_message
json.message @message

json.bill_item do
  json.id           @bill_item.id
  json.bill_id      @bill_item.bill_id
  json.good_id      @bill_item.good_id
  json.quantity     @bill_item.quantity
  json.subtotal     format('%.2f', @bill_item.calculate_subtotal)
  json.total        format('%.2f', @bill_item.calculate_total(@bill.discount.value))
  json.created_at   @bill_item.created_at
  json.updated_at   @bill_item.updated_at
  json.cancelled_at @bill_item.time_cancel

  json.bill do
    json.id           @bill.id
    json.total        format('%.2f', @bill.calculate_total)
    json.subtotal     format('%.2f', @bill.calculate_subtotal)
    json.closed_at    @bill.time_close
    json.cancelled_at @bill.time_cancel
  end

  json.good do
    json.id       @bill_item.good.id
    json.name     @bill_item.good.name
    json.price    format('%.2f', @bill_item.good.price)
    json.subtotal format('%.2f', @bill_item.calculate_subtotal)
    json.total    format('%.2f', @bill_item.calculate_total(@bill.discount.value))
  end
end
