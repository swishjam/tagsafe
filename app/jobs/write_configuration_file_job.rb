class WriteConfigurationFileJob < ApplicationJob
  queue_as :default

  def perform(organization)
    ConfigurationManager::Publisher.new(organization).publish_current_configuration_to_cdn
  end
end