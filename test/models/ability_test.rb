require 'test_helper'

class AbilityTest < ActiveSupport::TestCase
  context "Within context" do
    should "verify the abilities of admin users to do everything" do
      create_admin_abilities
      assert @alex_ability.can? :manage, :all
    end

    should "verify the abilities of manager users" do
      create_manager_abilities
      # no global privileges
      deny @kathryn_ability.can? :manage, :all
      # testing particular abilities
      deny @kathryn_ability.can? :manage, PayGrade
      deny @kathryn_ability.can? :manage, PayGradeRate
      deny @kathryn_ability.can? :manage, Job
      assert @kathryn_ability.can? :manage, Shift
      assert @kathryn_ability.can? :manage, ShiftJob

      assert @kathryn_ability.can? :index, Store
      assert @kathryn_ability.can? :show, @oakland
      deny @kathryn_ability.can? :show, @cmu
      deny @kathryn_ability.can? :create, Store
      deny @kathryn_ability.can? :update, Store

      assert @kathryn_ability.can? :index, Assignment
      assert @kathryn_ability.can? :show, @assign_ralph
      deny @kathryn_ability.can? :show, @assign_cindy
      deny @kathryn_ability.can? :create, Assignment
      deny @kathryn_ability.can? :update, Assignment

      assert @kathryn_ability.can? :index, Employee
      assert @kathryn_ability.can? :show, @kathryn
      assert @kathryn_ability.can? :show, @ralph
      deny @kathryn_ability.can? :show, @cindy
      deny @kathryn_ability.can? :create, Employee
      assert @kathryn_ability.can? :edit, @kathryn
      assert @kathryn_ability.can? :edit, @ralph
      deny @kathryn_ability.can? :edit, @cindy
      assert @kathryn_ability.can? :update, @kathryn
      assert @kathryn_ability.can? :update, @ralph
      deny @kathryn_ability.can? :update, @cindy
    end

    should "verify the abilities of employee users" do
      create_employee_abilities
      # no global privileges
      deny @ralph_ability.can? :manage, :all
      # testing particular abilities
      deny @ralph_ability.can? :manage, PayGrade
      deny @ralph_ability.can? :manage, PayGradeRate
      deny @ralph_ability.can? :manage, Job
      deny @ralph_ability.can? :manage, Store
      deny @ralph_ability.can? :manage, ShiftJob

      assert @ralph_ability.can? :index, Assignment
      assert @ralph_ability.can? :show, @assign_ralph
      deny @ralph_ability.can? :show, @assign_cindy
      deny @ralph_ability.can? :create, Assignment
      deny @ralph_ability.can? :update, Assignment

      deny @ralph_ability.can? :index, Employee
      deny @ralph_ability.can? :show, @kathryn
      assert @ralph_ability.can? :show, @ralph
      deny @ralph_ability.can? :show, @cindy
      deny @ralph_ability.can? :create, Employee
      deny @ralph_ability.can? :edit, @kathryn
      assert @ralph_ability.can? :edit, @ralph
      deny @ralph_ability.can? :update, @kathryn
      assert @ralph_ability.can? :update, @ralph
    end

  end
end