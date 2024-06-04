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

    if current_user == @comment.user
      @comment.destroy
      redirect_to @comment.commentable, notice: t('controllers.common.notice_destroy', name: @comment.commentable.model_name.human), status: :see_other
    else
      redirect_to @comment.commentable, alert: t('errors.messages.unauthorized')
    end
  end

  protected

  def comment_params
    params.require(:comment).permit(:content, :commentable_type, :commentable_id)
  end
end
