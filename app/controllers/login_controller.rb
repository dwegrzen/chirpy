class LoginController < ApplicationController
  before_action :disallow_user, only: [:new, :create]


  def new
  end

  def create
    @user = User.find_by(name: params[:name])
    if @user
      if @user.authenticate(params[:password])
        session[:user_id] = @user.id
        redirect_to :root
      else
        render :new
      end
    else
      render :new
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to :root
  end

  private

  def disallow_user
    if current_user
      redirect_to :root
    end
  end

end
