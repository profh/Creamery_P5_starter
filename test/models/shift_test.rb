require 'test_helper'

class ShiftTest < ActiveSupport::TestCase
  # Matchers
  should belong_to(:assignment)
  should have_one(:employee).through(:assignment)
  should have_one(:store).through(:assignment)
  should have_many(:shift_jobs)
  should have_many(:jobs).through(:shift_jobs)

  should validate_presence_of(:assignment_id)
  should allow_value("pending").for(:status)
  should allow_value("started").for(:status)
  should allow_value("finished").for(:status)
  should_not allow_value("bad").for(:status)
  should_not allow_value("").for(:status)
  should_not allow_value(10).for(:status)
  should_not allow_value("start").for(:status)
  should_not allow_value(nil).for(:status)

  # Context
  context "Given context" do
    setup do 
      create_stores
      create_employees
      create_pay_grades
      create_assignments
      create_shifts
    end

    # test scopes...
    should "have a scope for completed shifts" do
      create_jobs
      create_shift_jobs
      assert_equal [@shift_ralph_1, @shift_ralph_2], Shift.completed.sort_by{|s| s.date}
      destroy_shift_jobs
      destroy_jobs
    end
    
    should "have a scope for incomplete shifts" do
      create_jobs
      create_shift_jobs
      assert_equal [@shift_ralph_3, @shift_ralph_4, @shift_kathryn, @shift_cindy], Shift.incomplete.sort_by{|s| s.date}
      destroy_shift_jobs
      destroy_jobs
    end
    
    should "have a scope called for_store" do
      assert_equal [@shift_cindy], Shift.for_store(@cmu).sort_by{|s| s.date}
      assert_equal 5, Shift.for_store(@oakland).size
    end
    
    should "have a scope called for_employee" do
      assert_equal [@shift_ralph_1, @shift_ralph_2, @shift_ralph_3, @shift_ralph_4], Shift.for_employee(@ralph).sort_by{|s| s.date}
      assert_equal [@shift_cindy], Shift.for_employee(@cindy)
    end
    
    should "have a scope for past shifts" do
      assert_equal [@shift_ralph_1, @shift_ralph_2, @shift_ralph_3], Shift.past.sort_by{|s| s.date}
    end
    
    should "have a scope for upcoming shifts" do
      assert_equal [@shift_ralph_4, @shift_kathryn, @shift_cindy], Shift.upcoming.sort_by{|s| s.date}
    end
    
    should "have a scope for pending shifts" do
      assert_equal [@shift_ralph_4, @shift_cindy], Shift.pending.sort_by{|s| s.date}
    end

    should "have a scope for started shifts" do
      assert_equal [ @shift_kathryn], Shift.started.sort_by{|s| s.date}
    end

    should "have a scope for finished shifts" do
      assert_equal [@shift_ralph_1, @shift_ralph_2, @shift_ralph_3], Shift.finished.sort_by{|s| s.date}
    end

    should "have a scope called for_next_days" do
      assert_equal [@shift_ralph_4, @shift_kathryn], Shift.for_next_days(0)
      assert_equal [@shift_ralph_4, @shift_kathryn, @shift_cindy], Shift.for_next_days(2).sort_by{|s| s.date}
    end
    
    should "have a scope called for_past_days" do
      assert_equal [@shift_ralph_3], Shift.for_past_days(1)
      assert_equal [@shift_ralph_2,@shift_ralph_3], Shift.for_past_days(2).sort_by{|s| s.date}
      assert_equal 3, Shift.for_past_days(3).size
    end

    should "have a scope called for_dates" do
      date_range = DateRange.new(5.days.ago.to_date, 2.days.ago.to_date)
      assert_equal [@shift_ralph_1,@shift_ralph_2], Shift.for_dates(date_range).sort_by{|s| s.date}
    end
    
    should "have a scope to order chronologically" do
      assert_equal ['Ralph','Ralph','Ralph','Kathryn','Ralph','Cindy'], Shift.chronological.map{|s| s.employee.first_name}
    end

    should "have a scope to order by store name" do
      assert_equal ['CMU','Oakland','Oakland','Oakland','Oakland','Oakland'], Shift.by_store.map{|s| s.store.name}
    end
    
    should "have a scope to order by employee name" do
      assert_equal ['Crawford, Cindy','Janeway, Kathryn','Wilson, Ralph','Wilson, Ralph','Wilson, Ralph','Wilson, Ralph'], Shift.by_employee.map{|s| s.employee.name}
    end

    # test validations
    should "only accept date data for date field" do
      @shift_kj_bad = FactoryBot.build(:shift, assignment: @assign_kathryn, date: "FRED")
      deny @shift_kj_bad.valid?
      @shift_kj_bad2 = FactoryBot.build(:shift, assignment: @assign_kathryn, date: "14:00:00")
      deny @shift_kj_bad2.valid?
      @shift_kj_bad3 = FactoryBot.build(:shift, assignment: @assign_kathryn, date: 2020)
      deny @shift_kj_bad3.valid?
      @shift_kj_good = FactoryBot.build(:shift, assignment: @assign_kathryn, date: 2.weeks.ago.to_date)
      assert @shift_kj_good.valid?
    end
    
    should "not allow date to be nil" do
      @shift_kj_bad = FactoryBot.build(:shift, assignment: @assign_kathryn, date: nil)
      deny @shift_kj_bad.valid?
    end
    
    should "ensure that shift dates do not precede the assignment start date" do
      @shift_kj_bad = FactoryBot.build(:shift, assignment: @assign_kathryn, date: 2.years.ago.to_date)
      deny @shift_kj_bad.valid?
      @shift_kj_good = FactoryBot.build(:shift, assignment: @assign_kathryn, date: 2.weeks.ago.to_date)
      assert @shift_kj_good.valid?
    end
    
    should "only accept time data for start time" do 
      @shift_kj_bad2 = FactoryBot.build(:shift, assignment: @assign_kathryn, start_time: "12:66")
      deny @shift_kj_bad2.valid?
      @shift_kj_bad3 = FactoryBot.build(:shift, assignment: @assign_kathryn, start_time: 2011)
      deny @shift_kj_bad3.valid?
      @shift_kj_good = FactoryBot.build(:shift, assignment: @assign_kathryn, start_time: Time.local(2000,1,1,12,0,0))
      assert @shift_kj_good.valid?
    end
    
    should "only accept time data for end time" do 
      @shift_kj_bad3 = FactoryBot.build(:shift, assignment: @assign_kathryn, end_time: 2020)
      deny @shift_kj_bad3.valid?
      @shift_kj_good = FactoryBot.build(:shift, assignment: @assign_kathryn, start_time: Time.local(2000,1,1,12,0,0), end_time: Time.local(2000,1,1,16,0,0))
      assert @shift_kj_good.valid?
    end
    
    should "not allow start time to be nil" do
      @shift_kj_bad = FactoryBot.build(:shift, assignment: @assign_kathryn, start_time: nil)
      deny @shift_kj_bad.valid?
    end
    
    should "allow end time can be nil" do
      @shift_kj_good = FactoryBot.build(:shift, assignment: @assign_kathryn, end_time: nil)
      assert @shift_kj_good.valid?
    end
    
    should "ensure that shift end times do not precede the shift start time" do
      @shift_kj_bad = FactoryBot.build(:shift, assignment: @assign_kathryn, end_time: Time.local(2000,1,1,10,0,0))
      deny @shift_kj_bad.valid?
      @shift_kj_good = FactoryBot.build(:shift, assignment: @assign_kathryn, end_time: Time.local(2000,1,1,14,0,0))
      assert @shift_kj_good.valid?
    end
    
    should "ensure that shift are only given to current assignments" do
      @shift_ben_bad = FactoryBot.build(:shift, assignment: @assign_ben)
      deny @shift_ben_bad.valid?
      @shift_kj_good = FactoryBot.build(:shift, assignment: @assign_kathryn)
      assert @shift_kj_good.valid?
    end
    
    # test report_completed? method
    should "have a report_completed? method that works properly" do
      create_jobs
      create_shift_jobs
      deny @shift_cindy.report_completed?
      assert @shift_ralph_2.report_completed?
      destroy_shift_jobs
      destroy_jobs
    end
    
    # test callback to see that end_time is set to 3 hours afterwards
    should "have a callback which sets end time to three hours on create, but not on update" do
      # end_time is set on create
      @shift_kj_good = FactoryBot.create(:shift, assignment: @assign_kathryn, start_time: Time.local(2000,1,1,14,0,0), end_time: nil)
      assert_equal "17:00:00", @shift_kj_good.end_time.strftime("%H:%M:%S")
      # end_time is left alone on update
      assert_equal "14:00:00", @shift_kathryn.end_time.strftime("%H:%M:%S")
      @shift_kathryn.notes = "She did a good job today."
      @shift_kathryn.start_time = Time.local(2000,1,1,12,0,0)
      @shift_kathryn.save!
      assert_equal "14:00:00", @shift_kathryn.end_time.strftime("%H:%M:%S")
      # test end_date not defaulted if set to some value
      @shift_kj_long = FactoryBot.create(:shift, assignment: @assign_kathryn, start_time: Time.local(2000,1,1,12,0,0), end_time: Time.local(2000,1,1,22,0,0))
      assert_equal "22:00:00", @shift_kj_long.end_time.strftime("%H:%M:%S")
    end

    # test duration method
    should "have a method which calculates the duration of the shift, rounded to quarter-hours" do
      # test rounding up end_time
      assert_equal 3.0, @shift_kathryn.duration
      @shift_kathryn.end_time -= 1.minute
      assert_equal 3.0, @shift_kathryn.duration
      @shift_kathryn.end_time += 2.minute
      assert_equal 3.25, @shift_kathryn.duration
      @shift_kathryn.end_time += 12.minute
      assert_equal 3.25, @shift_kathryn.duration
      @shift_kathryn.end_time += 5.minute
      assert_equal 3.5, @shift_kathryn.duration
      # test rounding down start_time
      assert_equal 1.0, @shift_ralph_3.duration
      @shift_ralph_3.start_time += 2.minute
      assert_equal 1.0, @shift_ralph_3.duration
      @shift_ralph_3.start_time -= 5.minute
      assert_equal 1.25, @shift_ralph_3.duration
    end

    should "allow shifts that are pending to be destroyed" do
      assert @shift_cindy.status == 'pending'
      assert @shift_cindy.destroy
    end
    
    should "not allow shifts that have started or finished to be destroyed" do
      deny @shift_ralph_1.status == 'pending'
      deny @shift_ralph_1.destroy
    end

  end
end
