# require needed files
require './lib/tasks/helpers/stores'
require './lib/tasks/helpers/employees'
require './lib/tasks/helpers/pay_grades'
require './lib/tasks/helpers/jobs'
require './lib/tasks/helpers/assignments'
require './lib/tasks/helpers/shifts'
require './lib/tasks/helpers/shift_jobs'


module Populator  
  include Populator::Stores
  include Populator::Employees
  include Populator::PayGrades
  include Populator::Jobs
  include Populator::Assignments
  include Populator::Shifts
  include Populator::ShiftJobs
end