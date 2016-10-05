class ChatsController < ApplicationController

  layout "user_dashboard_layout"

  def index
    @chats = Chat.all
  end

  def new
    @chat = Chat.new
  end

  def create
    @chat = current_user.chats.build(chat_params)
    if @chat.save
      flash[:success] = 'Chat room added!'
      redirect_to chats_path
    else
      render 'new'
    end
  end

  def show
    @chat = Chat.includes(:messages).find_by(id: params[:id])
    @message = Message.new
  end

  def showChatsWithMessageCounts
    @chats = Chat.all
  end

  private

  def chat_params
    params.require(:chat).permit(:title)
  end
end
