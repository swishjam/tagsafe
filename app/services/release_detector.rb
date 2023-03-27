class ReleaseDetector
  MOCKED_USER_AGENT = 'Mozilla/5.0 (Windows NT 6.1; Win64; x64; rv:59.0) Gecko/20100101 Firefox/59.0'

  def initialize(tag)
    @tag = tag
    ReleaseCheck.create(tag: @tag)
  end

  def capture_new_tag_version_if_necessary
    content = get_tag_content
    return false unless !content.nil? && should_capture_new_tag_version?(content)
      
    TagManager::TagVersionCapturer.new(tag: @tag, content: content).capture_new_tag_version!
  end

  private

  def get_tag_content
    resp = HTTParty.get(@tag.full_url, headers: { 'User-Agent': MOCKED_USER_AGENT })
    if resp.code < 300
      resp.to_s
    else
      Resque.logger.error "Invalid Tag #{@tag.full_url}, endpoint returned a #{resp.code} response."
      nil
    end
  end

  def should_capture_new_tag_version?(content)
    current_tag_version = @tag.most_recent_tag_version
    current_tag_version.nil? || Digest::MD5.hexdigest(content) != current_tag_version.hashed_content
  end
end