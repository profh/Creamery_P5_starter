class CreateAssignments < ActiveRecord::Migration[5.2]
  def change
    create_table :assignments do |t|
      t.references :store, null: false, foreign_key: true
      t.references :employee, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.references :pay_grade, null: false, foreign_key: true

      # t.timestamps
    end
  end
end
