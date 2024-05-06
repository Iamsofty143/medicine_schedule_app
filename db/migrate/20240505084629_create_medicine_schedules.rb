class CreateMedicineSchedules < ActiveRecord::Migration[7.1]
  def change
    create_table :medicine_schedules do |t|
      t.string :disease
      t.date :start_date
      t.date :end_date
      t.integer :status, default: 0
      t.references :patient, null: false, foreign_key: true
    end
  end
end
