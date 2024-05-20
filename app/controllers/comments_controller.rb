class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    return unless @comment.save

    redirect_to @comment.commentable, notice: t('controllers.common.notice_create', name: Comment.model_name.human)
  end

  protected

  def comment_params
    params.require(:comment).permit(:content, :commentable_type, :commentable_id)
  end
end
