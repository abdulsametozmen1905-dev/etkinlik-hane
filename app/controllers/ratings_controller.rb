class RatingsController < ApplicationController
  before_action :require_user_logged_in
  before_action :set_event
  before_action :require_confirmed_registration

  def create
    @rating = @event.ratings.build(rating_params)
    @rating.user = current_user

    if @rating.save
      redirect_to @event, notice: "Puanınız başarıyla kaydedildi."
    else
      redirect_to @event, alert: @rating.errors.full_messages.to_sentence
    end
  end

  def update
    @rating = current_user.ratings.find(params[:id])

    if @rating.update(rating_params)
      redirect_to @event, notice: "Puanınız güncellendi."
    else
      redirect_to @event, alert: @rating.errors.full_messages.to_sentence
    end
  end

  private

  def set_event
    @event = Event.find(params[:event_id])
  end

  def rating_params
    params.require(:rating).permit(:score)
  end

  def require_user_logged_in
    redirect_to login_path, alert: "Lütfen önce giriş yapın." unless current_user
  end

  def require_confirmed_registration
    unless @event.registrations.confirmed.exists?(user_id: current_user.id)
      redirect_to @event, alert: "Puan verebilmek için etkinliğe kayıtlı olmalısınız."
    end
  end
end