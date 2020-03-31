class AssignmentsController < ApplicationController
  before_action :set_assignment, only: [:show, :edit, :terminate, :destroy]

  def index
    # for phase 3 only
      @current_assignments = Assignment.current.chronological.paginate(page: params[:page]).per_page(10)
      @past_assignments = Assignment.past.chronological.paginate(page: params[:page]).per_page(10)
  end

  def new
    @assignment = Assignment.new
    @assignment.employee_id = params[:employee_id] unless params[:employee_id].nil?
  end

  def create
    @assignment = Assignment.new(assignment_params)
    if @assignment.save
      redirect_to assignments_path, notice: "Successfully added the assignment."
    else
      render action: 'new'
    end
  end

  def terminate
    if @assignment.terminate
      redirect_to assignments_path, notice: "Assignment for #{@assignment.employee.proper_name} terminated."
    end
  end

  def destroy
    @assignment.destroy
    redirect_to assignments_path, notice: "Removed assignment from the system."
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_assignment
    @assignment = Assignment.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def assignment_params
    params.require(:assignment).permit(:store_id, :employee_id, :start_date)
  end

end

