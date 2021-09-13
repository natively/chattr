class PostsController < ApplicationController
  before_action :set_post, only: %i[show edit update destroy]

  before_action :authorize_poster!, only: %i[edit update destroy]

  # GET /posts
  def index
    @posts = Post.homepage(params[:page])
  end

  # GET /posts/1
  def show
    @replies = @post.replies.includes(:user).order(created_at: :asc)
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit; end

  # POST /posts
  def create
    @post = Post.new(post_params.merge(user: current_user))

    respond_to do |format|
      if @post.save
        format.html do
          redirect_to @post, notice: 'Post was successfully created.'
        end
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html do
          redirect_to @post, notice: 'Post was successfully updated.'
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  def destroy
    @post.update(deleted: true)

    respond_to do |format|
      format.html do
        redirect_to posts_url, notice: 'Post was successfully destroyed.'
      end
    end
  end

  private

  def authorize_poster!
    raise Exceptions::User::NotAuthorized unless @post.user == current_user
  end

  # Only allow a list of trusted parameters through.
  def post_params
    params.require(:post).permit(:title, :content)
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_post
    @post = Post.find(params[:id])
  end
end
