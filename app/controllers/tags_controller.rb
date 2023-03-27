class TagsController < LoggedInController
  def index
    @tags = current_organization.tags
    @breadcrumbs = [{ text: 'Tags' }]
  end

  def show
    @tag = current_organization.tags.find(params[:id])
    @breadcrumbs = [{ text: 'Tags', url: tags_path }, { text: @tag.hostname_and_path }]
  end

  def new
    @breadcrumbs = [{ text: 'Tags', url: tags_path }, { text: 'Host new tag' }]
  end

  def update
    @tag = current_organization.tags.find(params[:id])
    if @tag.update(update_tag_params)
      flash[:banner] = { type: 'success', message: "Updated live tag version to #{@tag.currently_live_tag_version.sha}." }
      redirect_to tag_path(@tag)
    else
      flash[:banner] = { type: 'error', message: @tag.errors.full_messages.join(', ') }
      redirect_to tag_path(@tag)
    end
  end

  def create
    @tag = current_organization.tags.new(tag_params)
    if @tag.save
      redirect_to tag_path(@tag)
    else
      render turbo_stream: turbo_stream.replace(
        "new_tag",
        partial: 'tags/form',
        locals: {
          tag: @tag,
          error_message: @tag.errors.full_messages.join(', '),
        }
      )
    end
  end

  def destroy
    @tag = current_organization.tags.find(params[:id])
    @tag.destroy
    flash[:banner] = { type: 'success', message: "You are no longer hosting #{@tag.hostname_and_path}" }
    redirect_to root_path
  end

  private

  def tag_params
    params.require(:tag).permit(:full_url)
  end

  def update_tag_params
    params.require(:tag).permit(:currently_live_tag_version_id)
  end
end
