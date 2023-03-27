class RegistrationsController < LoggedOutController
  skip_before_action :verify_authenticity_token
  
  def new
    redirect_to root_path if current_user.present?
  end

  def create
    org = Organization.new(organization_params)
    if org.save
      user = org.users.first
      set_current_user(user)
      url_to_go_to = session[:redirect_url] || root_path
      session.delete(:redirect_url)
      redirect_to url_to_go_to
    else
      render turbo_stream: turbo_stream.replace(
        'registration_form',
        partial: 'registrations/form',
        locals: { user: org.users.first }
      )
    end
  end

  private

  def organization_params
    params.require(:organization).permit(:name, users_attributes: [:email, :first_name, :last_name, :password])
  end
end