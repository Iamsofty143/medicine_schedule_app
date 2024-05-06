class Medicine < ApplicationRecord
  enum frequency: { daily: 0, weekly: 1, life_long: 2 , custom: 3}
  enum status: { active: 0, in_active: 1 }

  belongs_to :medicine_schedule

  before_validation :calculate_end_date
  validates :name, :frequency, :schedule, :status, presence: true
  validates :number_of_pill, presence: true, numericality: { only_integer: true, greater_than: 0 }
  validate :validate_number_of_frequency, :validate_start_date

  private

  def validate_number_of_frequency
    return if frequency == 'life_long'
    errors.add(:number_of_frequency, "must be present and greater than 0") if number_of_frequency.nil? || number_of_frequency <= 0
  end

  def validate_start_date
    errors.add(:start_date, "Start date should be present and greater than or equal to today") unless start_date.present? && start_date >= Date.today
  end

  def calculate_end_date
    return unless number_of_frequency.present? && start_date.present?
      self.end_date = case frequency
          when "daily", "custom"
            start_date + number_of_frequency.days
          when "weekly"
            start_date + number_of_frequency.weeks
          else
            nil
          end
  end

end
