class AddCurrentlyLiveTagVersionToTags < ActiveRecord::Migration[6.1]
  def up
    add_reference :tags, :currently_live_tag_version
    Tag.all.each do |tag|
      tag.update(currently_live_tag_version_id: tag.most_recent_tag_version&.id)
    end
  end
end
