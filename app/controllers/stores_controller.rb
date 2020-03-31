class StoresController < ApplicationController

  before_action :set_store, only: [:show, :edit, :update, :destroy]


  def index
    # get data on all stores and paginate the output to 10 per page
    @active_stores = Store.active.alphabetical.paginate(page: params[:page]).per_page(10)
    @inactive_stores = Store.inactive.alphabetical.paginate(page: params[:ipage]).per_page(10)
  end

  def show
    @current_managers = @store.assignments.current.map{|a| a.employee}.sort_by{|e| e.name}.select{|e| e.role == 'manager'}
    @current_employees = @store.assignments.current.map{|a| a.employee}.sort_by{|e| e.name}
  end

  def new
    @store = Store.new
  end

  def edit
  end

  def create
    @store = Store.new(store_params)
    if @store.save
      redirect_to @store, notice: "Successfully added #{@store.name} to the system."
    else
      render action: 'new'
    end
  end

  def update
    if @store.update_attributes(store_params)
      redirect_to @store, notice: "Updated store information for #{@store.name}."
    else
      render action: 'edit'
    end
  end

  private
  # Use callbacks to share common setup or constraints between actions.
  def set_store
    @store = Store.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def store_params
    params.require(:store).permit(:name, :street, :city, :phone, :state, :zip, :active)
  end

end
