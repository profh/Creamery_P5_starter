module Populator
  module PayGrades

    def create_pay_grades_and_rates
      # create the grades
      @m1 = FactoryBot.create(:pay_grade, level: 'M1')
      @m2 = FactoryBot.create(:pay_grade, level: 'M2')
      @c1 = FactoryBot.create(:pay_grade, level: 'C1')
      @c2 = FactoryBot.create(:pay_grade, level: 'C2')
      @c3 = FactoryBot.create(:pay_grade, level: 'C3')

      # create the rates for each grade
      @c1_t0 = FactoryBot.create(:pay_grade_rate, pay_grade: @c1, rate: 7.75, start_date: 24.months.ago.to_date, end_date: 12.months.ago.to_date)
      @c1_t1 = FactoryBot.create(:pay_grade_rate, pay_grade: @c1, rate: 8.75, start_date: 12.months.ago.to_date, end_date: 2.months.ago.to_date)
      @c1_t2 = FactoryBot.create(:pay_grade_rate, pay_grade: @c1, rate: 9.75, start_date: 2.months.ago.to_date, end_date: nil)

      @c2_t0 = FactoryBot.create(:pay_grade_rate, pay_grade: @c2, rate: 8.95, start_date: 23.months.ago.to_date, end_date: 11.months.ago.to_date)
      @c2_t1 = FactoryBot.create(:pay_grade_rate, pay_grade: @c2, rate: 10.25, start_date: 11.months.ago.to_date, end_date: nil)

      @c3_t0 = FactoryBot.create(:pay_grade_rate, pay_grade: @c3, rate: 11.50, start_date: 22.months.ago.to_date, end_date: nil)

      @m1_t0 = FactoryBot.create(:pay_grade_rate, pay_grade: @m1, rate: 19.75, start_date: 24.months.ago.to_date, end_date: 13.months.ago.to_date)
      @m1_t1 = FactoryBot.create(:pay_grade_rate, pay_grade: @m1, rate: 20.75, start_date: 13.months.ago.to_date, end_date: nil)
      @m2_t0 = FactoryBot.create(:pay_grade_rate, pay_grade: @m2, rate: 25.00, start_date: 20.months.ago.to_date, end_date: nil)
    end

  end
end