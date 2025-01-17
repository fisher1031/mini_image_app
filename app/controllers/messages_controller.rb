class MessagesController < ApplicationController
  before_action :set_message, only: [:edit, :update]

  def index
    @messages = Message.all.order(created_at: :desc)
  end

  def new
    @message = Message.new
  end

  def create
    @message = Message.new(message_params)
    if @message.save
    else
      render :new
    end
  end

  def edit
  end

  def update
    if @message.update(message_params)
    else
      render :edit
    end
  end

  def show
    @message = Message.find(params[:id])
    @like = Like.new
    @comment = Comment.new
    @comments = @message.comments.includes(:user)
  end

  def destroy
    message = Message.find(params[:id])
    message.destroy
  end

  def search
    @messages = Message.search(params[:keyword])
    unless user_signed_in?
      redirect_to root_path
    end
  end

  private
  def message_params
    params.require(:message).permit(:content, :name, :place, images: []).merge(user_id: current_user.id)
  end

  def set_message
    @message = Message.find(params[:id])
  end
end