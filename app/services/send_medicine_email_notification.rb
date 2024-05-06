require 'mailtrap'
class SendMedicineEmailNotification

  def self.notification_send(email, title, body)
    require "mailtrap"

    mail = Mailtrap::Mail::Base.new(
      from:
        {
          email: "mailtrap@demomailtrap.com",
          name: "Mailtrap Test",
        },
      to: [
        {
          email: email,
        }
      ],
      subject: title,
      text: body,
      category: "Integration Test"
    )

    client = Mailtrap::Client.new(api_key: '965e9beb5454ed3583eea11305dcdee1')
    response = client.send(mail)
    puts response
  end
end

