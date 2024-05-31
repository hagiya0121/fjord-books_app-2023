# frozen_string_literal: true

class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user
    return unless @comment.save

    redirect_to @comment.commentable, notice: t('controllers.common.notice_create', name: Comment.model_name.human)
  end

  def destroy
    @comment = Comment.find(params[:id])
    return unless current_user == @comment.user

    commentable = @comment.commentable
    @comment.destroy
    redirect_to commentable, notice: t('controllers.common.notice_destroy', name: commentable.model_name.human), status: :see_other
  end

  protected

  def comment_params
    params.require(:comment).permit(:content, :commentable_type, :commentable_id)
  end
end
