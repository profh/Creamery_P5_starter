require 'test_helper'

class JobTest < ActiveSupport::TestCase
  # Matchers
  should have_many(:shift_jobs)
  should have_many(:shifts).through(:shift_jobs)

  should validate_presence_of(:name)

  # Context
  context "Given context" do
    setup do 
      create_jobs
    end
    
    should "have all active jobs accounted for" do
      assert_equal 3, Job.active.size 
      assert_equal [@cashier,@making,@mopping], Job.active.sort_by{|job| job.name}
    end

    should "have all inactive jobs accounted for" do
      assert_equal 1, Job.inactive.size 
      assert_equal [@mover], Job.inactive
    end

    should "have a make_active method" do
      deny @mover.active
      @mover.make_active
      @mover.reload
      assert @mover.active
    end

    should "have a make_inactive method" do
      assert @cashier.active
      @cashier.make_inactive
      @cashier.reload
      deny @cashier.active
    end

    should "list jobs alphabetically" do
      assert_equal [@cashier, @making, @mopping, @mover], Job.alphabetical
    end

    should "allow jobs with no associated shifts to be destroyed" do
      assert @cashier.shift_jobs.empty?
      assert @cashier.destroy
    end
    
    should "not allow jobs with associated shifts to be destroyed" do
      create_stores
      create_employees
      create_pay_grades
      create_assignments
      create_shifts
      create_shift_jobs
      deny @cashier.shift_jobs.empty?
      deny @cashier.destroy
    end

  end
end
