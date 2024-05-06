class CreateMedicine < ActiveRecord::Migration[7.1]
  def change
    create_table :medicines do |t|
      t.string :name
      t.integer :frequency #daily, weekly , life_long, custom
      t.integer :number_of_frequency, default: 0 # 14 day
      t.integer :number_of_pill, default: 0
      t.jsonb :set_of_time, default: {}
      t.json :schedule, default: {}
      t.integer :status, default: 0
      t.datetime :start_date
      t.datetime :end_date
      t.timestamps
      t.references :medicine_schedule, null: false, foreign_key: true
    end
  end
end
