namespace :db do
  desc 'Erase and fill database'
  # creating a rake task within db namespace called 'populate'
  # executing 'rake db:populate' will cause this script to run
  task :populate => :environment do
    require 'factory_bot_rails'
    require './lib/tasks/populator'
    include Populator

    # Step 0: Reset of the databases (restart from scratch)
    Rake::Task['db:drop'].invoke
    Rake::Task['db:create'].invoke
    Rake::Task['db:migrate'].invoke
    Rake::Task['db:test:prepare'].invoke
    puts 'Reset the dev and test databases'

    # Step 1: Create stores, pay grades, pay rates, and jobs
    all_stores = create_stores
    puts 'Created stores'

    create_pay_grades_and_rates
    puts 'Created pay grades and rates'

    create_jobs
    puts 'Created jobs'

    # Step 2: Create admins and a manager assigned to each store
    create_admins
    puts 'Created Alex and Mark as admins'
    create_managers_and_assignments_for(all_stores)
    puts 'Created managers and assigned each to a store'

    # Step 3: Create 140 employees
    puts 'Start creating employees'
    all_employees = create_employees
    puts 'Created 140 employees'

    # Step 4: for each employee create some assignments
    puts 'Start creating assignments'
    create_assignments_for(all_employees)
    puts 'Created a set of assignments for each employee'

    # Step 5: Create some shifts for each employee's current assignment
    puts 'Start creating shifts'
    create_shifts_for(all_employees)
    puts 'Created shifts for employees'

    # Step 6: Add some jobs to past shifts
    puts 'Start linking past shifts to jobs'
    create_shift_jobs_for_past_shifts
    puts 'Added jobs to past shifts'

  end
end