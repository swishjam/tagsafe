class ApplicationRecord < ActiveRecord::Base
  self.abstract_class = true

  scope :older_than, -> (timestamp, timestamp_column: :created_at) { where("#{timestamp_column} < ?", timestamp).order("#{timestamp_column.to_s} DESC") }
  scope :older_than_or_equal_to, -> (timestamp, timestamp_column: :created_at) { where("#{timestamp_column} <= ?", timestamp).order("#{timestamp_column.to_s} DESC") }
 
  scope :more_recent_than, -> (timestamp, timestamp_column: :created_at) { where("#{timestamp_column} > ?", timestamp).order("#{timestamp_column.to_s} DESC") }
  scope :more_recent_than_or_equal_to, -> (timestamp, timestamp_column: :created_at) { where("#{timestamp_column} >= ?", timestamp).order("#{timestamp_column.to_s} DESC") }

  scope :between, -> (start_ts, end_ts) { older_than(end_ts).more_recent_than(start_ts) }

  scope :most_recent_first, -> (timestamp_column: :created_at) { order("#{timestamp_column} DESC") }
  scope :most_recent_last, -> (timestamp_column: :created_at) { order("#{timestamp_column} ASC") }

  def column_changed?(column)
    saved_changes[column.to_s].present?
  end

  def column_became_non_nil?(column)
    column_changed?(column) && !saved_changes[column][1].nil? && saved_changes[column][0].nil?
  end

  def column_changed_to?(column, value)
    column_changed?(column) && saved_changes[column][1] == value && saved_changes[column][0] != value
  end
end
