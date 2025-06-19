class PostsController < ApplicationController
  before_action :require_user, except: [:index, :show]

  def index
    @post = Post.where(status: "public")
  end

  def new
    @post = Post.new
  end

  def create
    @post = Post.new(post_params)
    @post.user = current_user
    if @post.save
      flash[:notice] = "Post created"
      redirect_to @post
    else
      flash.now[:alert] = "Post could not be created"
      render 'new'
    end
  end

  def show
    @post = Post.find(params[:id])
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy

    redirect_to root_path, status: :see_other
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :status)
  end

  def require_user
      unless logged_in?
        flash[:alert] = "You must be logged in to perform that action."
        redirect_to login_path
      end
    end
end
