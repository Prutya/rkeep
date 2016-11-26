Role.create({ name: :admin })    unless Role.exists?(name: :admin)
Role.create({ name: :employee }) unless Role.exists?(name: :employee)

unless Discount.exists?
  Discount.create({ value:  0.00 })
  Discount.create({ value:  5.00 })
  Discount.create({ value: 10.00 })
  Discount.create({ value: 20.00 })
end
