class CommentsController < ApplicationController
  before_action :require_user

  def create
    @post = Post.find(params[:post_id])
    @comment = @post.comments.create(comment_params)
    @comment.user = current_user # Assuming you have a 'current_user' helper method

    if @comment.save
      flash[:notice] = "Comment was successfully created."
      redirect_to post_path(@post)
    else
      flash[:alert] = "Comment could not be saved."
      redirect_to post_path(@post)
    end
  end

  def destroy
    @post = Post.find(params[:post_id])
    @comment = @post.comments.find(params[:id])
    @comment.destroy
    redirect_to post_path(@post), status: :see_other
  end

  private

  def comment_params
    params.require(:comment).permit(:content)
  end

  def require_user
    unless logged_in?
      flash[:alert] = "You must be logged in to perform that action."
      redirect_to login_path
    end
  end
end
