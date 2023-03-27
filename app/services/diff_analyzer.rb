class DiffAnalyzer
  def initialize(
    new_content:,
    previous_content:, 
    num_lines_of_context: 10_000, 
    diff_output_format: :html, 
    include_plus_and_minus_in_html: true, 
    include_diff_info: false
  )
    @new_content = new_content
    @previous_content = previous_content

    @num_lines_of_context = num_lines_of_context
    @diff_output_format = diff_output_format
    @include_plus_and_minus_in_html = include_plus_and_minus_in_html
    @include_diff_info = include_diff_info
  end

  def html_diff
    @html_diff ||= diffy_diff.to_s(:html)
  end
  alias html_unified_diff html_diff

  def html_split_diff_left
    @html_split_diff_left ||= diffy_split_diff.left
  end
  alias html_split_diff_deletions html_split_diff_left

  def html_split_diff_right
    @html_split_diff_right ||= diffy_split_diff.right
  end
  alias html_split_diff_additions html_split_diff_right

  def num_additions
    calculate_metrics
    @num_additions
  end

  def num_deletions
    calculate_metrics
    @num_deletions
  end

  def total_changes
    num_additions + num_deletions
  end

  private

  def calculate_metrics
    return if @metrics_calculated
    @num_additions = 0
    @num_deletions = 0
    diffy_diff.each do |line|
      case line
      when /^\+/ then @num_additions += 1
      when /^-/ then @num_deletions +=1
      end
    end
    @num_additions -= 1 if @include_diff_info
    @num_deletions -= 1 if @include_diff_info
    @num_additions < 0 ? 0 : @num_additions
    @num_deletions < 0 ? 0 : @num_deletions
    @metrics_calculated = true
  end

  def diffy_diff
    @diffy_diff ||= Diffy::Diff.new(
      @previous_content&.force_encoding('UTF-8'), 
      @new_content.force_encoding('UTF-8'), 
      format: @diff_output_format, 
      include_plus_and_minus_in_html: @include_plus_and_minus_in_html,
      include_diff_info: @include_diff_info,
      context: @num_lines_of_context
    )
  end

  def diffy_split_diff
    @diffy_split_diff ||= Diffy::SplitDiff.new(
      @previous_content&.force_encoding('UTF-8'),
      @new_content.force_encoding('UTF-8'), 
      format: @diff_output_format, 
      include_plus_and_minus_in_html: @include_plus_and_minus_in_html,
      include_diff_info: @include_diff_info,
      context: @num_lines_of_context
    )
  end
end