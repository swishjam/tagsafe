class ReleaseCheckerJob < ApplicationJob
  queue_as :normal
  
  def perform
    start = Time.now
    tags = Tag.all
    Resque.logger.info "Checking #{tags.count} tags for new versions"
    tags.each{ |tag| ReleaseDetector.new(tag).capture_new_tag_version_if_necessary }
    Resque.logger.info "Finished checking #{tags.count} tags for new versions in #{Time.now - start} seconds"
  end
end