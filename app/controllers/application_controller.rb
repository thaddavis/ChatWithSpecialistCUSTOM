class ApplicationController < ActionController::Base
  include Pundit

  protect_from_forgery with: :exception

  before_action :authenticate_user!

  before_action :active_users

  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized

  private

    def user_not_authorized
      flash[:alert] = "Access denied."
      redirect_to (request.referrer || root_path)
    end

    def active_users
      if current_user && current_user.timedout?(current_user.current_sign_in_at)
        sign_out(current_user)
      end

      ActionCable.server.broadcast "appearances_channel",
                                 message_type: "subscribed",
                                 message: render_message()
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
