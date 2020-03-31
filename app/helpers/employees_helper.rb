module EmployeesHelper
  def number_to_ssn(num)
    "#{num[0..2]}-#{num[3..4]}-#{num[5..8]}"
  end
end
