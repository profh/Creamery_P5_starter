class CreatePayGrades < ActiveRecord::Migration[5.2]
  def change
    create_table :pay_grades do |t|
      t.string :level
      t.boolean :active

      # t.timestamps
    end
  end
end
