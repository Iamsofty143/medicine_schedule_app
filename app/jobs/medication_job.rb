class MedicationJob
  include Sidekiq::Job

  queue_as :medicine_reminder

  def perform(medicine_id, account_id)
    account = Patient.find_by(id: account_id)
    medicine = Medicine.find_by(id: medicine_id) # Rails 7 doesn't allow to pass object directly
    notification = account.email_notifications.create(title: "Medical Reminder", body: "#{account.name}, It's time for your medication - #{medicine.name}! Take your scheduled dose now.")

    SendMedicineEmailNotification.notification_send(account.email, notification.title, notification.body)

    data = schedule_notification(medicine, Date.today)
    if data[:next_schedule]
      time_to_perform = Time.parse(data[:time_difference]) - 15.minutes
      MedicationJob.perform_at(Time.now + 1.minutes, medicine.id, account.id)
    end
  end
end