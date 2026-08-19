class SessionsController < ApplicationController
  def new
    
  end

  def create
    
    user = User.find_by(email: params[:email])

    if user && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to root_path, notice: "Başarıyla giriş yaptınız!"
    else
      flash.now[:alert] = "E-posta veya şifre hatalı."
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path, notice: "Çıkış yapıldı."
  end
end