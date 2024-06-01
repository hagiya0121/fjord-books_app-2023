# frozen_string_literal: true

class CommentsController < ApplicationController
  def create
    @comment = Comment.new(comment_params)
    @comment.user = current_user

    if @comment.save
      redirect_to @comment.commentable, notice: t('controllers.common.notice_create', name: Comment.model_name.human)
    else
      redirect_to @comment.commentable, alert: t('activerecord.errors.messages.record_invalid', errors: @comment.errors.full_messages.join(','))
    end
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
