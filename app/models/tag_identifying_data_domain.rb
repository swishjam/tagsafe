class TagIdentifyingDataDomain < ApplicationRecord
  belongs_to :tag_identifying_data

  def apply_to_tags_without_tag_identifying_data
    Tag.includes(:tag_identifying_data).where(tag_identifying_data: { id: nil }).map do |tag|
      next unless matches?(tag)
      tag.update!(tag_identifying_data: tag_identifying_data)
    end.compact!
  end

  def matches?(tag)
    return true if tag.url_hostname == url_pattern
    split_domain = tag.url_hostname.split('.')
    domain_url_pattern_for_tag = "*.#{split_domain[split_domain.length - 2..].join('.')}"
    domain_url_pattern_for_tag == url_pattern
  end
end