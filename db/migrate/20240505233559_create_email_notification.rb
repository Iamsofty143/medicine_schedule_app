class CreateEmailNotification < ActiveRecord::Migration[7.1]
  def change
    create_table :email_notifications do |t|
      t.string :title
      t.string :body
      t.references :patient, null: false, foreign_key: true
      t.timestamps
    end
  end
end
