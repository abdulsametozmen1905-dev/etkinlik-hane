class RegistrationsController < ApplicationController
  before_action :require_login

  def create
  @event = Event.find(params[:event_id])

  if @event.date_time <= Time.current
    redirect_to @event, alert: "Bu etkinlik başladığı için kayıt olamazsınız."
    return
  end

    @registration = @event.registrations.build(user: current_user)

    if @registration.save
      # Kayıt başarılı olduğunda bilgilendirme e-postasını gönder
      RegistrationMailer.confirmation_email(@registration).deliver_later

      redirect_to @event, notice: "Etkinliğe başarıyla katıldınız. Bilgilendirme e-postası gönderildi."
    else
      redirect_to @event, alert: "Etkinliğe katılırken bir hata oluştu."
    end
  end

  def destroy
    @registration = current_user.registrations.find(params[:id])
    @event = @registration.event
    @registration.destroy
    redirect_to event_path(@event), alert: "Kaydınız iptal edildi, kontenjan güncellendi."
  end

  private

  def require_login
    unless logged_in?
      redirect_to login_path, alert: "Bu işlem için giriş yapmalısınız."
    end
  end
end