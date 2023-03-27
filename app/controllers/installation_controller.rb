class InstallationController < LoggedInController
  def install
    @organization_key = current_organization.unique_key
  end
end