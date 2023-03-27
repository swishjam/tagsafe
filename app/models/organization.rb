class Organization < ApplicationRecord
  has_many :tags
  has_many :users

  accepts_nested_attributes_for :users

  validates :unique_key, uniqueness: true
  before_create :set_unique_key
  after_create_commit :publish_configuration_json

  def publish_configuration_json
    WriteConfigurationFileJob.perform_later(self)
  end

  def hosted_configuration_url
    "https://#{ENV['HOST_CDN_HOSTNAME']}#{hosted_configuration_pathname}"
  end

  def hosted_configuration_pathname
    "/#{unique_key}/config.json"
  end

  private

  def set_unique_key
    loop do
      key = "org_#{SecureRandom.hex(10)}"
      return self.unique_key = key unless Organization.find_by(unique_key: key)
    end
  end
end