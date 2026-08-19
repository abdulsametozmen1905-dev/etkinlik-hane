class UsersController < ApplicationController
  before_action :require_login, only: [:events]

  def new
    @user = User.new
  end

  def create
    @user = User.new(user_params)
    if @user.save
      session[:user_id] = @user.id
      redirect_to root_path, notice:
    else
      render :new, status: :unprocessable_entity
    end
  end

  def events
    @created_events = current_user.events
    @registered_events = current_user.registered_events
  end

  private

  def user_params
    params.require(:user).permit(:email, :password, :password_confirmation)
  end

  def require_login
    unless logged_in?
      redirect_to login_path, alert:
    end
  end
end