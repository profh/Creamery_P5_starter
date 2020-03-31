require 'test_helper'

class AssignmentTest < ActiveSupport::TestCase
  # Matchers
  should belong_to(:store)
  should belong_to(:employee)
  should belong_to(:pay_grade)
  should have_many(:shifts)

  should validate_presence_of(:store_id)
  should validate_presence_of(:employee_id)
  should validate_presence_of(:pay_grade_id)
  should allow_value(7.weeks.ago.to_date).for(:start_date)
  should allow_value(2.years.ago.to_date).for(:start_date)
  should_not allow_value(1.week.from_now.to_date).for(:start_date)
  should_not allow_value("bad").for(:start_date)
  should_not allow_value(nil).for(:start_date)

  # Context
  context "Given context" do
    setup do 
      create_stores
      create_employees
      create_pay_grades
      create_assignments
    end

    should "have a scope 'for_store' that works" do
      assert_equal 4, Assignment.for_store(@cmu).size
      assert_equal 2, Assignment.for_store(@oakland).size
    end
    
    should "have a scope 'for_employee' that works" do
      assert_equal 2, Assignment.for_employee(@ben).size
      assert_equal 1, Assignment.for_employee(@kathryn).size
    end
    
    should "have a scope 'for_pay_grade' that works" do
      assert_equal 3, Assignment.for_pay_grade(@c1).size
      assert_equal 0, Assignment.for_pay_grade(@c2).size
      assert_equal 2, Assignment.for_pay_grade(@m1).size
      assert_equal 1, Assignment.for_pay_grade(@m2).size
    end
    
    should "have a scope 'for_role' that works" do
      assert_equal 3, Assignment.for_role("employee").size
      assert_equal 3, Assignment.for_role("manager").size
    end
    
    should "have all the assignments listed alphabetically by store name" do
      assert_equal ["CMU", "CMU", "CMU", "CMU", "Oakland", "Oakland"], Assignment.by_store.map{|a| a.store.name}
    end
    
    should "have all the assignments listed chronologically by start date" do
      assert_equal ["Ben", "Ralph", "Kathryn", "Ed", "Cindy", "Ben"], Assignment.chronological.map{|a| a.employee.first_name}
    end
    
    should "have all the assignments listed alphabetically by employee name" do
      assert_equal ["Crawford", "Gruberman", "Janeway", "Sisko", "Sisko", "Wilson"], Assignment.by_employee.map{|a| a.employee.last_name}
    end

    should "have a scope to find all assignments for a given date" do
      assert_equal 3, Assignment.for_date(11.months.ago.to_date).size
      assert_equal [@assign_ben, @assign_cindy, @assign_ed], Assignment.for_date(11.months.ago.to_date).sort_by{|a| a.employee.first_name}
    end

    should "have a scope to find all current assignments for a store or employee" do
      assert_equal 2, Assignment.current.for_store(@cmu).size
      assert_equal 2, Assignment.current.for_store(@oakland).size
      assert_equal 1, Assignment.current.for_employee(@ben).size
      assert_equal 0, Assignment.current.for_employee(@ed).size
    end
    
    should "have a scope to find all past assignments for a store or employee" do
      assert_equal 2, Assignment.past.for_store(@cmu).size
      assert_equal 0, Assignment.past.for_store(@oakland).size
      assert_equal 1, Assignment.past.for_employee(@ben).size
      assert_equal 0, Assignment.past.for_employee(@cindy).size
    end

    should "allow for a end date in the past (or today) but after the start date" do
      # Note that we've been testing end_date: nil for a while now so safe to assume works...
      @assign_alex = FactoryBot.build(:assignment, employee: @alex, store: @oakland, start_date: 3.months.ago.to_date, end_date: 1.month.ago.to_date, pay_grade: @c1)
      assert @assign_alex.valid?
      @second_assignment_for_alex = FactoryBot.build(:assignment, employee: @alex, store: @oakland, start_date: 3.weeks.ago.to_date, end_date: Time.now.to_date, pay_grade: @c1)
      assert @second_assignment_for_alex.valid?
    end
    
    should "not allow for a end date in the future or before the start date" do
      # since Ed finished his last assignment a month ago, let's try to assign the lovable loser again ...
      @second_assignment_for_ed = FactoryBot.build(:assignment, employee: @ed, store: @oakland, start_date: 2.weeks.ago.to_date, end_date: 3.weeks.ago.to_date, pay_grade: @c1)
      deny @second_assignment_for_ed.valid?
      @third_assignment_for_ed = FactoryBot.build(:assignment, employee: @ed, store: @oakland, start_date: 2.weeks.ago.to_date, end_date: 3.weeks.from_now.to_date, pay_grade: @c1)
      deny @third_assignment_for_ed.valid?
    end
    
    should "identify a non-active store as part of an invalid assignment" do
      inactive_store = FactoryBot.build(:assignment, store: @hazelwood, employee: @ed, start_date: 1.day.ago.to_date, end_date: nil, pay_grade: @c1)
      deny inactive_store.valid?
    end

    should "identify a non-active pay_grade as part of an invalid assignment" do
      inactive_pay_grade = FactoryBot.build(:assignment, store: @hazelwood, employee: @ed, start_date: 1.day.ago.to_date, end_date: nil, pay_grade: @c0)
      deny inactive_pay_grade.valid?
    end
    
    should "identify a non-active employee as part of an invalid assignment" do
      @fred = FactoryBot.build(:employee, :first_name => "Fred", :active => false)
      inactive_employee = FactoryBot.build(:assignment, store: @oakland, employee: @fred, start_date: 1.day.ago.to_date, end_date: nil, pay_grade: @c1)
      deny inactive_employee.valid?
    end
    
    should "end the current assignment if it exists before adding a new assignment for an employee" do
      @promote_kathryn = FactoryBot.create(:assignment, employee: @kathryn, store: @oakland, start_date: 1.day.ago.to_date, end_date: nil, :pay_grade => @m2)
      assert_equal 1.day.ago.to_date, @kathryn.assignments.first.end_date
      @promote_kathryn.destroy
    end

    should "terminate an assignment effectively as of today" do
      create_shifts
      # precondition: an active assignment with a pending shift
      assert_nil @assign_cindy.end_date
      assert_equal 1, @assign_cindy.shifts.pending.count
      @assign_cindy.terminate
      @assign_cindy.reload
      # postcondition: an ended assignment with no pending shifts
      assert_equal Date.current, @assign_cindy.end_date
      assert_equal 0, @assign_cindy.shifts.pending.count
    end

    should "not terminate a completed assignment" do
      assert_equal 6.months.ago.to_date, @assign_ben.end_date
      @assign_ben.terminate
      assert_equal 6.months.ago.to_date, @assign_ben.end_date
    end

    should "allow assignments with no shifts to be destroyed" do
      assert @promote_ben.shifts.empty?
      assert @promote_ben.destroy
    end

    should "allow assignments with only pending shifts to be destroyed" do
      create_shifts
      deny @assign_cindy.shifts.pending.empty?
      assert @assign_cindy.shifts.started.empty?
      assert @assign_cindy.shifts.finished.empty?
      assert @assign_cindy.destroy
    end
    
    should "not allow assignments with non-pending shifts to be destroyed" do
      create_shifts
      # assignments with finished shifts cannot be destroyed
      deny @assign_ralph.shifts.finished.empty?
      deny @assign_ralph.destroy
      # assignments with started (but not finished) shifts also can't be destroyed
      assert @assign_kathryn.shifts.finished.empty?
      deny @assign_kathryn.shifts.started.empty?
      deny @assign_kathryn.destroy
    end
  end
end
