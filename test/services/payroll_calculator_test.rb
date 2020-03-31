require 'test_helper'

class PayrollCalculatorTest < ActiveSupport::TestCase

  context "Given context" do
    setup do 
      create_employees
      create_stores
      create_pay_grades
      create_pay_grade_rates
      create_assignments
      create_shifts
      # a shift that starts 2 minutes late and finishes 3 minutes early to test rounding rules
      @shift_kathryn_yesterday = FactoryBot.create(:shift, assignment: @assign_kathryn, date: 1.day.ago.to_date, start_time: Time.local(2000,1,1,13,2,0,), end_time: Time.local(2000,1,1,16,58,0,))
      @calculator = PayrollCalculator.new(DateRange.new(4.days.ago.to_date, 1.day.ago.to_date))
    end
  

    should "have properly created accessor methods" do
      assert @calculator.respond_to?(:date_range)
      assert @calculator.respond_to?(:start_date)
      assert @calculator.respond_to?(:end_date)
      assert @calculator.respond_to?(:payrolls)
      assert @calculator.respond_to?(:payrolls=)
      assert !@calculator.respond_to?(:date_range=)
      assert !@calculator.respond_to?(:start_date=)
      assert !@calculator.respond_to?(:end_date=)
    end

    should "create a list of payroll objects" do
      payroll = @calculator.create_payroll_for(@oakland)
      assert_equal 4.days.ago.to_date, @calculator.start_date
      assert_equal 1.day.ago.to_date, @calculator.end_date
      assert_equal 2, payroll.count  # four shifts total, but only two payrolls
      assert_equal "Wilson, Ralph", payroll.first.employee_name
      assert_equal "C1", payroll.first.pay_grade
      assert_equal 9.75, payroll.first.pay_rate
      assert_equal 8, payroll.first.hours # three shifts of 3, 4, and 1 hour
      assert_equal 78, payroll.first.pay_earned
      assert_equal "Janeway, Kathryn", payroll.last.employee_name
      assert_equal "M1", payroll.last.pay_grade
      assert_equal 20.75, payroll.last.pay_rate
      assert_equal 4, payroll.last.hours # one shift of 4 hours; rounding tested here
      assert_equal 83, payroll.last.pay_earned
    end

  end
end