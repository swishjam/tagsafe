module ApplicationHelper
  def current_user
    @current_user ||= User.find(session[:current_user]) unless session[:current_user].nil?
  rescue ActiveRecord::RecordNotFound => e
    log_user_out
    redirect_to new_session_path
  end

  def current_organization
    @current_organization ||= current_user&.organization
  end

  def user_is_anonymous?
    current_user.nil?
  end

  def set_current_user(user)
    session[:current_user] = user.id
  end

  def log_user_out
    session.delete(:current_user)
  end
end
