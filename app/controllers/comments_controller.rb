class CommentsController < ApplicationController
  before_action :require_login

  def create
    @event = Event.find(params[:event_id])
    @comment = @event.comments.new(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @event, notice: "Yorum başarıyla eklendi."
    else
      redirect_to @event, alert: "Yorum eklenirken bir hata oluştu."
    end
  end

  def destroy
    @event = Event.find(params[:event_id])
    @comment = @event.comments.find(params[:id])

    if @comment.user == current_user || current_user.admin?
      @comment.destroy
      redirect_to @event, notice: "Yorum silindi."
    else
      redirect_to @event, alert: "Bu yorumu silme yetkiniz yok."
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def require_login
    unless logged_in?
      redirect_to login_path, alert: "Giriş yapmalısınız."
    end
  end
end