class LoggedOutController < ApplicationController
  layout 'logged_out_layout'
  # before_action :ensure_logged_out

  def ensure_logged_out
    redirect_to container_tag_snippets_path(@container) unless current_user.nil?
  end
end