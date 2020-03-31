require 'test_helper'

class TimeClockTest < ActiveSupport::TestCase

  context "Given context" do
    setup do 
      create_employees
      create_stores
      create_pay_grades
      create_pay_grade_rates
      create_assignments
      create_shifts
      @time_clock = TimeClock.new(@shift_ralph_4)
    end
    

    should "have properly created accessor methods" do
      assert @time_clock.respond_to?(:shift)
      assert !@time_clock.respond_to?(:shift=)
    end

    should "properly start a shift" do
      assert_equal "pending", @shift_ralph_4.status
      assert_equal 13, @shift_ralph_4.start_time.hour
      assert_equal 0, @shift_ralph_4.start_time.min
      @time_clock.start_shift_at(Time.local(2000,1,1, 12, 45, 0))
      @shift_ralph_4.reload
      assert_equal "started", @shift_ralph_4.status
      assert_equal 12, @shift_ralph_4.start_time.hour
      assert_equal 45, @shift_ralph_4.start_time.min      
    end

    should "properly end a shift" do
      assert_equal "pending", @shift_ralph_4.status
      assert_equal 14, @shift_ralph_4.end_time.hour
      assert_equal 0, @shift_ralph_4.end_time.min
      @time_clock.end_shift_at(Time.local(2000,1,1, 15, 30, 0))
      @shift_ralph_4.reload
      assert_equal "finished", @shift_ralph_4.status
      assert_equal 15, @shift_ralph_4.end_time.hour
      assert_equal 30, @shift_ralph_4.end_time.min      
    end

  end
end