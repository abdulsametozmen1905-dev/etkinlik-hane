class EventMailerPreview < ActionMailer::Preview
  def registration_confirmation
    # Önizleme için veritabanındaki ilk kaydı örnek alıyoruz
    registration = Registration.first || Registration.new(
      user: User.first,
      event: Event.first
    )
    
    EventMailer.registration_confirmation(registration)
  end
end