class PostsController < ApplicationController
  before_filter :authenticate_user!
  
  expose_decorated(:posts) { Post.all }
  expose_decorated(:post, attributes: :post_params)
  expose(:tag_cloud) { Post.tags_with_weight }
  expose(:comments){(current_user == post.user ? post.comments : post.comments.select{|c| !c.abusive?})}
  expose(:comments) { post.comments }
  expose(:author) { post.user.to_s}

  def index
  end

  def new
  end

  def edit
    if session[:user_id] != post.user_id
      flash[:notice] ="Sorry, you can't edit this post"
      redirect_to post
    end
  end

  def update
    if post.save
      render action: :index
    else
      render :new
    end
  end

  def destroy
    if current_user.owner? post
      post.destroy
    else
      flash[:notice] ="Sorry, you can't delete this post"
    end
    render action: :index
  end

  def show
  end

  def mark_archived
    # post = Post.find params[:id]
    post.archive!
    render action: :index
  end

  def create
    post.user = current_user
    if post.save
      redirect_to action: :index
    else
      render :new
    end
  end

  private

  def post_params
    return if %w{mark_archived}.include? action_name
    params.require(:post).permit(:body, :title, :tags, :comments)
  end

end
