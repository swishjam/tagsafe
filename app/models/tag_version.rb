class TagVersion < ApplicationRecord
  belongs_to :tag

  def host_url_pathname
    URI.parse(tag.full_url).path
  end

  def is_currently_live?
    tag.currently_live_tag_version_id == id
  end

  def sha
    hashed_content.slice(0, 8)
  end

  def original_content
    @original_content ||= original_content_host_url ? HTTParty.get(original_content_host_url).to_s : nil
  end

  def minified_content
    @minified_content ||= minified_content_host_url ? HTTParty.get(minified_content_host_url).to_s : nil
  end

  def formatted_content
    @formatted_content ||= formatted_content_host_url ? HTTParty.get(formatted_content_host_url).to_s : nil
  end

  def sha
    hashed_content.slice(0, 8)
  end

  def previous_version
    tag.tag_versions.older_than(created_at).most_recent_first.limit(1).first
  end

  def first_version?
    previous_version.nil?
  end
end