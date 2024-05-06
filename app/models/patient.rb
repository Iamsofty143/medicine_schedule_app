class Patient < ApplicationRecord
  
  enum status: { active: 0, in_active: 1, died:2 }

  belongs_to :user
  has_many :medicine_schedules, dependent: :destroy
  has_many :email_notifications, dependent: :destroy

  validates :name,:email, :time_zone, :status, presence: true
  validates :email, uniqueness: true


end
