class MedicineSchedule < ApplicationRecord

  belongs_to :patient
  
  has_many :medicines, dependent: :destroy
  validates :disease, :start_date, presence: true
end
