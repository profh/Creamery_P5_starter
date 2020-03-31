module Populator
  module Shifts

    def create_shifts_for(all_employees)
      count = 0
      # define three unequal shifts
      shift1_start = Time.local(2000,1,1,10,0,0)
      shift1_end   = Time.local(2000,1,1,14,30,0) # 4.5 hr shift
      shift2_start = Time.local(2000,1,1,14,30,0)
      shift2_end   = Time.local(2000,1,1,18,0,0)  # 3.5 hr shift
      shift3_start = Time.local(2000,1,1,18,0,0)
      shift3_end   = Time.local(2000,1,1,23,0,0)  # 5 hr shift

      shifts = [[shift1_start, shift1_end],[shift2_start, shift2_end],[shift3_start, shift3_end]]

      all_employees.each do |employee|
        assignment = employee.current_assignment
        num_past = rand(15..50)
        num_upcoming = rand(6)
        # create past shifts
        (1..num_past).each do |i|
          shift = shifts.sample
          FactoryBot.create(:shift, assignment: assignment, date: i.days.ago.to_date, start_time: shift[0], end_time: shift[1], status: 'finished')
          count += 1
          puts " -- created #{count} shifts" if (count % 100).zero?
        end

        # create upcoming shifts
        (0..num_upcoming).each do |i|
          shift = shifts.sample
          FactoryBot.create(:shift, assignment: assignment, date: i.days.from_now.to_date, start_time: shift[0], end_time: shift[1])
          count += 1
          puts " -- created #{count} shifts" if (count % 100).zero?
        end
      end
    end

  end
end