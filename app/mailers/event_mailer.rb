class EventMailer < ApplicationMailer
  default from: 'bildirim@etkinlikhane.com'

  def registration_confirmation(registration)
    @registration = registration
    @user = registration.user
    @event = registration.event

    mail(to: @user.email, subject: "Etkinlik Kaydınız Onaylandı: #{@event.title}")
  end
end