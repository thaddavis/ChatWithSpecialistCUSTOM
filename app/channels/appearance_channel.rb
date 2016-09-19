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
  end

  def appear(data)
  end

  def away
  end

  def render_message()
    usersForDisplay = ConnectedUsersForDisplay(ConnectedList.all)

    AppearancesController.render partial: 'appearances/appearance', locals: { current_user: current_user, connected_users: usersForDisplay }
  end

  def ConnectedUsersForDisplay(users)
    returnArray = []


    users.each do |i|

      user_hash = Hash.new

      user = User.find(i)

      user_hash[:email] = user.email
      user_hash[:last_sign_in_at] = user.last_sign_in_at

      returnArray << user_hash

    end

    returnArray
  end

end
