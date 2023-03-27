class NewTagJob < ApplicationJob
  queue_as :normal
  
  def perform(tag)
    ReleaseDetector.new(tag).capture_new_tag_version_if_necessary
  end
end