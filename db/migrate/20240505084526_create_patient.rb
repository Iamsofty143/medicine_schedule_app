class CreatePatient < ActiveRecord::Migration[7.1]
  def change
    create_table :patients do |t|
      t.string :name
      t.string :email
      t.string :time_zone
      t.integer :status, default: 0
      t.timestamps null: false
      t.references :user, null: false, foreign_key: true
    end
  end
end
