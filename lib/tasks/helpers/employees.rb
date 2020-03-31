module Populator
  module Employees
    require 'faker'

    def create_employees
    #   # create 200 general employees
      count = 0
      all_employees = Array.new
      140.times do
        count += 1
        puts " -- created #{count} employees" if (count % 10).zero?
        first_name = Faker::Name.first_name
        last_name = Faker::Name.last_name
        employee = FactoryBot.create(:employee, first_name: first_name, last_name: last_name)
        all_employees << employee
      end
      all_employees
    end

    def create_admins
      # Step 1a: Add Alex as admin and user
      ae = Employee.new
      ae.first_name = 'Alex'
      ae.last_name = 'Heimann'
      ae.ssn = '123456789'
      ae.date_of_birth = '1993-01-25'
      ae.phone = '412-268-3259'
      ae.role = 'admin'
      ae.active = true
      ae.username = 'alex'
      ae.password = 'secret'
      ae.password_confirmation = 'secret'
      ae.save!
      
      # Step 1b: Add Mark as employee and user
      me = Employee.new
      me.first_name = 'Mark'
      me.last_name = 'Heimann'
      me.ssn = '987654321'
      me.date_of_birth = '1993-01-25'
      me.phone = '412-268-8211'
      me.active = true
      me.role = 'admin'
      me.username = 'mark'
      me.password = 'secret'
      me.password_confirmation = 'secret'
      me.save!
    end

    def create_managers_and_assignments_for(all_stores)
      m1 = PayGrade.first
      all_stores.each do |store|
        first_name = Faker::Name.first_name
        last_name = Faker::Name.last_name
        manager = FactoryBot.create(:employee, first_name: first_name, last_name: last_name, username: "#{first_name.downcase}.#{last_name.downcase}", role: 'manager')
        assignment = FactoryBot.create(:assignment, employee: manager, store: store, start_date: 24.months.ago.to_date, end_date: nil, pay_grade: m1)
      end
    end
  end
end