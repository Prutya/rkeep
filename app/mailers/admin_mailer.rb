class AdminMailer < ApplicationMailer
  def shift_started(shift)
    admins = User
             .joins(assignments: :role)
             .where(roles: { name: :admin })

    admins.each do |admin|
      email = mail(to: admin.email, subject: 'Shift opened') do |format|
        format.html do
          render 'shift_started', locals: { shift: shift, admin: admin, employee: shift.users.first }
        end
      end
    end
  end

  def shift_ended(shift)
    admins = User
             .joins(assignments: :role)
             .where(roles: { name: :admin })

    admins.each do |admin|
      email = mail(to: admin.email, subject: 'Shift closed') do |format|
        format.html do
          render 'shift_started', locals: { shift: shift, admin: admin, employee: shift.users.first }
        end
      end
    end
  end
end
