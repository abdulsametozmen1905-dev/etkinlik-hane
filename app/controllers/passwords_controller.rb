class PasswordsController < ApplicationController
  before_action :require_user_logged_in

  def edit
    @user = current_user
  end

  def update
    @user = current_user

    if !@user.authenticate(params[:user][:current_password])
      @user.errors.add(:current_password, "mevcut şifreniz hatalı")
      render :edit, status: :unprocessable_entity
    elsif params[:user][:password].blank?
      @user.errors.add(:password, "yeni şifre boş bırakılamaz")
      render :edit, status: :unprocessable_entity
    elsif @user.update(password_params)
      redirect_to root_path, notice: "Şifreniz başarıyla güncellendi."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def require_user_logged_in
    redirect_to login_path, alert: "Lütfen önce giriş yapın." unless current_user
  end

  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end