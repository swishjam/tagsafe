class TagIdentifyingData < ApplicationRecord
  self.table_name = :tag_identifying_data
  has_one_attached :image, service: :tag_image_s3
  has_many :tags
  has_many :tag_identifying_data_domains, dependent: :destroy
  accepts_nested_attributes_for :tag_identifying_data_domains

  def self.for_tag(tag)
     split_domain = tag.url_host.split('.')
     domain_url_pattern_for_tag = "*.#{split_domain[split_domain.length - 2..].join('.')}"
    joins(:tag_identifying_data_domains).find_by("
      tag_identifying_data_domains.url_pattern = ? OR 
      tag_identifying_data_domains.url_pattern = ?", 
      tag.url_host, 
      domain_url_pattern_for_tag
    )
  end

  def apply_to_tags_without_tag_identifying_data
    Tag.includes(:tag_identifying_data).where(tag_identifying_data: { id: nil }).map do |tag|
      next unless matches?(tag)
      tag.update!(tag_identifying_data: self)
    end.compact!
  end


  def matches?(tag)
    matches = false
    tag_identifying_data_domains.each do |tag_identifying_data_domain|
      split_domain = tag.url_host.split('.')
      domain_url_pattern_for_tag = "*.#{split_domain[split_domain.length - 2..].join('.')}"
      if [tag.url_host, domain_url_pattern_for_tag].include?(tag_identifying_data_domain.url_pattern)
        matches = true
        break
      end
    end
    matches
  end
end