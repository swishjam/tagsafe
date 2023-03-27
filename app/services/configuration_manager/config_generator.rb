module ConfigurationManager
  class ConfigGenerator
    def initialize(organization)
      @organization = organization
    end

    def json_config
      tag_configs = "{"
      @organization.tags.each_with_index do |tag, i|
        next if tag.currently_live_tag_version.nil? || (tag.currently_live_tag_version.minified_content_host_url.nil? && tag.currently_live_tag_version.original_content_host_url.nil?) 
        tag_configs += "\"#{tag.full_url}\": \"#{tag.currently_live_tag_version.minified_content_host_url || tag.currently_live_tag_version.original_content_host_url}\""
        tag_configs += "," unless i == @organization.tags.count - 1
      end
      tag_configs += "}"
    end
  end
end