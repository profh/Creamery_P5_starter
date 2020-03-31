class EmployeesController < ApplicationController
  before_action :set_employee, only: [:show, :edit, :update, :destroy]

  def index
    # for phase 3 only
    @active_managers = Employee.managers.active.alphabetical.paginate(page: params[:page]).per_page(10)
    @active_employees = Employee.regulars.active.alphabetical.paginate(page: params[:page]).per_page(10)
    @inactive_employees = Employee.inactive.alphabetical.paginate(page: params[:page]).per_page(10)

  end

  def show
    retrieve_employee_assignments
  end

  def new
    @employee = Employee.new
  end

  def edit
  end

  def create
    @employee = Employee.new(employee_params)
    if @employee.save
      redirect_to @employee, notice: "Successfully added #{@employee.proper_name} as an employee."
    else
      render action: 'new'
    end
  end

  def update
    if @employee.update_attributes(employee_params)
      redirect_to @employee, notice: "Updated #{@employee.proper_name}'s information."
    else
      render action: 'edit'
    end
  end


  private
  # Use callbacks to share common setup or constraints between actions.
  def set_employee
    @employee = Employee.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def employee_params
    params.require(:employee).permit(:first_name, :last_name, :ssn, :phone, :date_of_birth, :role, :active)
  end

  def retrieve_employee_assignments
    @current_assignment = @employee.current_assignment
    @previous_assignments = @employee.assignments.to_a - [@current_assignment]
  end

end
