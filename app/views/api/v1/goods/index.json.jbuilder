json.status @status_message
json.message @message

json.goods @goods do |good|
  json.id    good.id
  json.name  good.name
  json.price format('%.2f', good.price)
end
