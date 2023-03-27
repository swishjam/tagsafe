class TagVersionsController < LoggedInController
  protect_from_forgery except: :content
  before_action :find_tag_and_tag_version

  def show
    @breadcrumbs = [ 
      { text: 'Tags', url: tags_path }, 
      { text: @tag.hostname_and_path, url: tag_path(@tag) },
      { text: "#{@tag_version.created_at.formatted_short} release" }
    ]
  end

  def diff
    previous_tag_version = @tag_version.previous_version
    formatted_content = TagManager::JsBeautifier.beautify_string!(@tag_version.original_content)
    previous_version_formatted_content = previous_tag_version ? TagManager::JsBeautifier.beautify_string!(previous_tag_version.original_content) : nil
    diff_analyzer = DiffAnalyzer.new(
      new_content: formatted_content,
      previous_content: previous_version_formatted_content,
      num_lines_of_context: 7,
      include_diff_info: true
    )
    render turbo_stream: turbo_stream.replace(
      "tag_version_#{@tag_version.id}_diff",
      partial: 'tag_versions/diff',
      locals: { 
        tag: @tag, 
        tag_version: @tag_version, 
        additions_html: diff_analyzer.html_split_diff_additions&.html_safe, 
        deletions_html: diff_analyzer.html_split_diff_deletions&.html_safe,
        num_additions: diff_analyzer.num_additions,
        num_deletions: diff_analyzer.num_deletions,
        total_changes: diff_analyzer.total_changes
      }
    )
  end

  private

  def find_tag_and_tag_version
    @tag = current_organization.tags.find(params[:tag_id])
    @tag_version = @tag.tag_versions.find(params[:id])
  end
end