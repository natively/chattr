# frozen_string_literal: true

# replies to posts
class RepliesController < ApplicationController
  before_action :set_reply, only: %i[update edit]

  before_action :authorize_poster!, only: %i[edit update]

  def create
    @reply = Reply.new(create_params)

    respond_to do |format|
      if @reply.save
        format.html do
          redirect_to @reply.post, notice: 'Reply was successfully created.'
        end
      else
        format.html { render :new, status: :unprocessable_entity }
      end
    end
  end

  def edit; end

  def new
    @reply = Reply.new

    @post_id = params[:post_id]
  end

  def update
    respond_to do |format|
      if @reply.update(update_params)
        format.html do
          redirect_to @reply.post, notice: 'Reply was successfully updated.'
        end
      else
        format.html { render :edit, status: :unprocessable_entity }
      end
    end
  end

  private

  def authorize_poster!
    raise Exceptions::User::NotAuthorized unless @reply.user == current_user
  end

  def create_params
    params
      .require(:reply)
      .permit(:post_id, :content)
      .merge(user: current_user)
  end

  def update_params
    params.require(:reply).permit(:content)
  end

  def set_reply
    @reply = Reply.find(params[:id])
  end
end
