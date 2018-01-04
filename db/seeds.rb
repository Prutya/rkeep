role_admin    = Role.find_or_create_by({ name: :admin })
role_employee = Role.find_or_create_by({ name: :employee })

unless Discount.exists?
  Discount.create!({ value:  0.00 })
  Discount.create!({ value:  5.00 })
  Discount.create!({ value: 10.00 })
  Discount.create!({ value: 20.00 })
end

unless User.exists?(email: 'admin@example.com')
  User.create!({
    email: 'admin@example.com',
    password: 'password',
    password_confirmation: 'password',
    first_name: 'Admin',
    last_name: 'Admin',
    phone: '+380501488228',
    roles: [role_admin, role_employee]
  })
end

unless User.exists?(email: 'employee@example.com')
  User.create!({
    email: 'employee@example.com',
    password: 'password',
    password_confirmation: 'password',
    first_name: 'Employee',
    last_name: 'Employee',
    phone: '+380501488228',
    roles: [role_employee]
  })
end

unless Table.any?
  Table.create!({ name: '1' })
  Table.create!({ name: '2' })
  Table.create!({ name: '3' })
  Table.create!({ name: '4' })
  Table.create!({ name: '5' })
  Table.create!({ name: '6' })
end

unless Good.any?
  Good.create!({ name: 'Water Sparkling', price: 20.00  })
  Good.create!({ name: 'Hookah Premium',  price: 150.00 })
end
