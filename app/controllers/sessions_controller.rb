class SessionsController < ApplicationController
  layout 'logged_out_layout'

  def new
    redirect_to root_path if current_user
    if params[:invite_token]
      @user_invite = UserInvite.find_by(token: params[:invite_token])
    end
  end

  def create
    user = User.find_by(email: params[:email].downcase)
    if user && user.authenticate(params[:password])
      set_current_user(user)
      url_to_go_to = session[:redirect_url] || root_path
      session.delete(:redirect_url)
      redirect_to url_to_go_to
    else
      render turbo_stream: turbo_stream.replace(
        "login_form",
        partial: 'sessions/form',
        locals: { 
          user: user,
          error_message: "Invalid email or password.",
        }
      )
    end
  end

  def destroy
    log_user_out
    redirect_to params[:redirect_path] || login_path
  end
end