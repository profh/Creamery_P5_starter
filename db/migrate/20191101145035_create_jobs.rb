class CreateJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :jobs do |t|
      t.string :name
      t.text :description
      t.boolean :active

      # t.timestamps
    end
  end
end
