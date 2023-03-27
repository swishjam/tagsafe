class LoggedInController < ApplicationController
  layout 'logged_in_layout'

  before_action :authorize!

  def authorize!
    if current_user.nil?
      log_user_out
      session[:redirect_url] = request.original_url
      redirect_to new_registration_path 
    end
  end
end