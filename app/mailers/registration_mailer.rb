class RegistrationMailer < ApplicationMailer
default from: "no-reply@etkinlikhane.com"

def confirmation_email(registration)
    @registration = registration
    @event = registration.event
    @user = registration.user

    mail(to: @user.email, subject: "Etkinlik Kaydı Başarılı: #{@event.title}")
end
end