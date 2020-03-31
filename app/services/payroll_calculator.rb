class PayrollCalculator
  def initialize(date_range)
    @date_range = date_range
    @start_date = date_range.start_date
    @end_date = date_range.end_date
    @payrolls = Hash.new
  end

  attr_reader :date_range, :start_date, :end_date
  attr_accessor :payrolls

  def create_payroll_for(store)
    all_shifts = Shift.for_store(store).for_dates(date_range)
    all_shifts.each do |shift|
      add_to_payrolls(shift)
    end
    # return an array of payroll objects, one for each employee
    # working shifts at the store during that date range
    return payrolls.values
  end

  private
  def add_to_payrolls(shift)
    employee = shift.employee
    payroll = get_or_set_employee_payroll_object(employee, shift)
    revised_payroll = increment_pay_earned(payroll, shift)
    payrolls[employee] = revised_payroll
  end

  def get_or_set_employee_payroll_object(employee, shift)
    if !payrolls.keys.include?(employee)
      payroll = Payroll.new(employee)
    else
      payroll = payrolls[employee]
    end
    payroll.pay_grade = employee.pay_grade_on(shift.date)
    payroll.pay_rate = employee.pay_rate_on(shift.date)
    return payroll
  end

  def increment_pay_earned(payroll, shift)
    payroll.hours += shift.duration
    payroll.pay_earned += (shift.duration) * (payroll.pay_rate)
    return payroll
  end

end