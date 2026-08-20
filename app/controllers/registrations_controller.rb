class RegistrationsController < ApplicationController
  before_action :require_user_logged_in
  before_action :set_event

  def create
    if @event.user_id == current_user.id
      redirect_to @event, alert: "Kendi oluşturduğunuz etkinliğe kayıt olamazsınız.", status: :see_other
      return
    end

    @registration = @event.registrations.build(user: current_user)

    if @event.full?
      @registration.status = "waitlisted"
    else
      @registration.status = "registered"
    end

    if @registration.save
      if @registration.confirmed?
        EventMailer.registration_confirmation(@registration).deliver_later
        redirect_to @event, notice: "Etkinliğe başarıyla kayıt oldunuz! Onay maili gönderildi.", status: :see_other
      else
        redirect_to @event, notice: "Kontenjan dolu olduğu için bekleme listesine eklendiniz.", status: :see_other
      end
    else
      redirect_to @event, alert: "Kayıt işlemi sırasında bir hata oluştu.", status: :see_other
    end
  end

  def destroy
    @registration = @event.registrations.find_by(user: current_user)
    if @registration&.destroy
      if @registration.confirmed? && (first_waitlisted = @event.registrations.waitlisted.order(created_at: :asc).first)
        first_waitlisted.update(status: "registered")
      end
      redirect_to @event, notice: "Kaydınız iptal edildi.", status: :see_other
    else
      redirect_to @event, alert: "İptal edilecek kayıt bulunamadı.", status: :see_other
    end
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def require_user_logged_in
    redirect_to login_path, alert: "Lütfen önce giriş yapın." unless current_user
  end
end