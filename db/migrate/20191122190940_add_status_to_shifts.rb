class AddStatusToShifts < ActiveRecord::Migration[5.2]
  def change
    add_column :shifts, :status, :string, default: "pending"
  end
end
