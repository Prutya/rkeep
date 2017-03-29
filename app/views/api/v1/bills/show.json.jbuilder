json.status @status_message
json.message @message

json.bill do
  json.id           @bill.id
  json.closed_at    @bill.time_close
  json.cancelled_at @bill.time_cancel

  json.items @bill.bill_items do |item|
    json.id            item.id
    json.bill_id       item.bill_id
    json.good_id       item.good_id
    json.quantity      item.quantity
    json.subtotal      format('%.2f', item.calculate_subtotal)
    json.total         format('%.2f', item.calculate_total(@bill.discount.value))
    json.created_at    item.created_at
    json.updated_at    item.updated_at
    json.cancelled_at  item.time_cancel

    json.good do
      json.id       item.good.id
      json.name     item.good.name
      json.price    format('%.2f', item.good.price)
      json.subtotal format('%.2f', item.calculate_subtotal)
      json.total    format('%.2f', item.calculate_total(@bill.discount.value))
    end
  end
end
