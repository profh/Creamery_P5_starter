class CreateShiftJobs < ActiveRecord::Migration[5.2]
  def change
    create_table :shift_jobs do |t|
      t.references :shift, null: false, foreign_key: true
      t.references :job, null: false, foreign_key: true

      # t.timestamps
    end
  end
end
