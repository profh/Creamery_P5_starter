require 'test_helper'

class ShiftJobTest < ActiveSupport::TestCase
  # Matchers
  should belong_to(:shift)
  should belong_to(:job)
  should validate_presence_of(:shift_id)
  should validate_presence_of(:job_id)

  # Context
  context "Given context" do
    setup do 
      create_stores
      create_employees
      create_pay_grades
      create_assignments
      create_shifts
      create_jobs
      create_shift_jobs
    end

    should "list shift jobs alphabetically by job" do
      assert_equal ['Cashier', 'Cashier', 'Mopping'], ShiftJob.alphabetical.map{|sj| sj.job.name}.sort
    end

    should "allow shift jobs to be added to shifts that are in the past" do
      @shift_in_past = FactoryBot.build(:shift_job, shift: @shift_ralph_3, job: @making)
      assert @shift_in_past.valid?, "#{@shift_in_past.shift.end_time}"
    end
      
    should "not allow shift jobs to be added to shifts that are in the future" do
      @shift_in_future = FactoryBot.build(:shift_job, shift: @shift_ed, job: @making)
      assert !@shift_in_future.valid?  #, "#{@shift_in_future.shift.end_time} - #{@shift_in_future.shift.date}"
    end
    
    should "allow active jobs to be added to shifts" do
      @shift_in_past = FactoryBot.build(:shift_job, shift: @shift_ralph_3, job: @making)
      assert @shift_in_past.valid?
    end
    
    should "not allow inactive jobs to be added to shifts" do
      @shift_in_past = FactoryBot.build(:shift_job, shift: @shift_ralph_3, job: @moving)
      deny @shift_in_past.valid?
    end

    should "not allow jobs to be added to non-existence shifts" do
      @shift_ralph_0 = FactoryBot.build(:shift, assignment: @assign_ralph, date: 4.days.ago.to_date)
      @nonexistent_shift = FactoryBot.build(:shift_job, shift: @shift_ralph_0, job: @cashier)
      deny @nonexistent_shift.valid?
    end

    should "not allow jobs to be added to future shifts" do
      @future_shift_job = FactoryBot.build(:shift_job, shift: @shift_cindy, job: @cashier)
      deny @future_shift_job.valid?
    end
  end
end
