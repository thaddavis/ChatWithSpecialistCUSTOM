# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class ChatsChannel < ApplicationCable::Channel
  include ActionController

  def subscribed
    stream_from "chats_#{params['chat_id']}_channel"
  end

  def unsubscribed
    # Any cleanup needed when channel is unsubscribed
  end

  def send_message(data)

    if current_user.timedout?(current_user.current_sign_in_at)
      ActionCable.server.broadcast "chats_#{data['chat_id']}_channel",
                                 message: 'timedout'
      return
    end

    current_user.messages.create!(body: data['message'], chat_id: data['chat_id'])

  end

end
