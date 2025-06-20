class SessionsController < ApplicationController
  def new
    if logged_in?
      flash[:alert] = "You're are already logged in"
      redirect_to root_path
    end
  end

  def create
    user = User.find_by(username: session_params[:username].downcase)

    if user && user.authenticate(session_params[:password])
      session[:user_id] = user.id
      flash[:notice] = "Logged in"
      redirect_to root_path
    else
      flash.now[:alert] = 'Invalid username or password'
      render :new, status: :unprocessable_entity
    end
  end

  def destroy
    session[:user_id] = nil
    flash[:notice] = "Logged out successfully."
    redirect_to root_path, status: :see_other
  end

  private

  def session_params
    params.require(:session).permit(:username, :password)
  end
end
