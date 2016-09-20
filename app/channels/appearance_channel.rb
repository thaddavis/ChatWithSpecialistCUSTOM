# Be sure to restart your server when you modify this file. Action Cable runs in a loop that does not support auto reloading.
class AppearanceChannel < ApplicationCable::Channel
  def subscribed
    stream_from "appearances_channel"
    ConnectedList.add(current_user.id)
    ActionCable.server.broadcast "appearances_channel",
                                 message_type: "subscribed",
                                 message: render_message()
  end

  def unsubscribed
    ConnectedList.remove(current_user.id)
    ActionCable.server.broadcast "appearances_channel",
                                 message_type: "subscribed",
                                 message: render_message()
  end

  def appear(data)
  end

  def away
  end

  def render_message()
    usersForDisplay = ConnectedUsersForDisplay(ConnectedList.all)

    AppearancesController.render partial: 'appearances/appearance', locals: { connected_users: usersForDisplay }
  end

end
