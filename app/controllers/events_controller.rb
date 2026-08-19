class EventsController < ApplicationController
  before_action :set_event, only: [:show, :edit, :update, :destroy]

  def index
    @events = Event.upcoming

    if params[:category_id].present?
      @events = @events.where(category_id: params[:category_id])
    end

    if params[:query].present?
      @events = @events.where("title LIKE ? OR description LIKE ?", "%#{params[:query]}%", "%#{params[:query]}%")
    end

    @events = @events.page(params[:page]).per(9)
  end

  def show
    @comment = Comment.new if defined?(Comment)
  end

  def new
    @event = Event.new
  end

  def edit
  end

  def create
    @event = current_user.events.build(event_params)

    if @event.save
      @event.registrations.create(user: current_user) if @event.respond_to?(:registrations)
      redirect_to @event, notice: "Etkinlik başarıyla oluşturuldu."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    if @event.update(event_params)
      redirect_to @event, notice: "Etkinlik başarıyla güncellendi."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @event.destroy
    redirect_to events_path, notice: "Etkinlik başarıyla silindi."
  end

  private

  def set_event
    @event = Event.find(params[:id])
  rescue ActiveRecord::RecordNotFound
    redirect_to events_path, alert: "Aradığınız etkinlik bulunamadı veya kaldırılmış."
  end

  def event_params
    params.require(:event).permit(:title, :description, :date_time, :location, :quota, :category_id, :cover_image)
  end
end