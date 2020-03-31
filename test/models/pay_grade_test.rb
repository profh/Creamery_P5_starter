require 'test_helper'

class PayGradeTest < ActiveSupport::TestCase
  # Matchers
  should have_many(:assignments)
  should have_many(:pay_grade_rates)
  should validate_presence_of(:level)

  # Context
  context "Given context" do
    setup do 
      create_pay_grades
    end

    should "have all active pay grades accounted for" do
      assert_equal 5, PayGrade.active.size 
      deny PayGrade.active.include?(@c0)
      assert_equal [@c1,@c2,@c3,@m1,@m2], PayGrade.active.sort_by{|pg| pg.level}
    end

    should "have all inactive pay grades accounted for" do
      assert_equal 1, PayGrade.inactive.size 
      deny PayGrade.inactive.include?(@m1)
      assert_equal [@c0], PayGrade.inactive
    end

    should "have a make_active method" do
      deny @c0.active
      @c0.make_active
      @c0.reload
      assert @c0.active
    end

    should "have a make_inactive method" do
      assert @c1.active
      @c1.make_inactive
      @c1.reload
      deny @c1.active
    end

    should "list pay grades alphabetically" do
      assert_equal [@c0, @c1, @c2, @c3, @m1, @m2], PayGrade.alphabetical
    end

    should "not allow pay grades to be destroyed for any reason" do
      deny @c1.destroy
    end

  end
end
