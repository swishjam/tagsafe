class Tag < ApplicationRecord
  belongs_to :organization
  belongs_to :tag_identifying_data, optional: true
  belongs_to :currently_live_tag_version, class_name: TagVersion.to_s, optional: true
  has_many :tag_versions, dependent: :destroy
  has_many :release_checks, dependent: :destroy

  before_create :set_parsed_url_attributes
  after_create :find_and_apply_tag_identifying_data
  # after_create_commit { NewTagJob.perform_later(self) }
  after_create_commit { ReleaseDetector.new(self).capture_new_tag_version_if_necessary }
  after_update :check_for_new_currently_live_tag_version

  def set_parsed_url_attributes
    parsed_url = URI.parse(self.full_url)
    self.url_host = parsed_url.host
    self.url_path = parsed_url.path
    self.url_query = parsed_url.query

    parsed_url.scheme = 'https' if parsed_url.scheme.nil?
    self.full_url = parsed_url.to_s
  rescue => e
    errors.add(:base, "Invalid URL: #{e.message}")
  end

  def friendly_name
    has_tag_identifying_data? ? tag_identifying_data.name : nil
  end

  def hostname_and_path
    url_host + url_path
  end

  def most_recent_tag_version
    tag_versions.most_recent_first.limit(1).first
  end

  def most_recent_release_check
    release_checks.most_recent_first.limit(1).first
  end

  def find_and_apply_tag_identifying_data(force_update = false)
    if full_url.present? && (!has_tag_identifying_data? || force_update)
      update!(tag_identifying_data: TagIdentifyingData.for_tag(self))
    end
  end

  def has_tag_identifying_data?
    tag_identifying_data_id.present?
  end

  def has_image?
    has_tag_identifying_data? && tag_identifying_data.image.attached?
  end

  def image_url
    has_image? ? tag_identifying_data.image.service_url : nil
  end

  private

  def check_for_new_currently_live_tag_version
    organization.publish_configuration_json if !saved_changes['currently_live_tag_version_id'].nil?
  end
end