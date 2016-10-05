# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class AppearanceChannel < ApplicationCable::Channel
  include ApplicationHelper

  def subscribed
    stream_from "appearances_channel"
    ConnectedList.add(current_user.email)
    ActionCable.server.broadcast "appearances_channel",
                                 message_type: "subscribed",
                                 message: render_message()
  end

  def unsubscribed
    ConnectedList.remove(current_user.email)
    ActionCable.server.broadcast "appearances_channel",
                                 message_type: "unsubscribed",
                                 message: render_message()
  end

  def change_status(data)
    ConnectedList.change_status(data['email'], data['status'])
    ActionCable.server.broadcast "appearances_channel",
                                 message_type: "unsubscribed",
                                 message: render_message()
  end

  def render_message()
    usersForDisplay = ConnectedUsersForDisplay(ConnectedList.all)
    AppearancesController.render partial: 'appearances/appearance', locals: { connected_users: usersForDisplay }
  end

end
