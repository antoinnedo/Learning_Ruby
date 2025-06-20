# SECURE EXAMPLE WITH PUNDIT
class PostsController < ApplicationController
  before_action :require_user, except: [:index, :show]
  before_action :set_post, only: [:show, :edit, :update, :destroy]

  def index
    @post = Post.where(status: "public")
  end

  def edit
    authorize @post
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
    authorize @post
    @post.destroy

    redirect_to root_path, status: :see_other
  end

  def update
      authorize @post
      if @post.update(post_params)
    end
  end

  private

  def post_params
    params.require(:post).permit(:title, :body, :status)
  end

  def set_post
    @post = Post.find(params[:id])
  end

  def require_user
    unless logged_in?
      flash[:alert] = "You must be logged in to perform that action."
      redirect_to login_path
    end
  end
end
