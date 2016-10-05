module ApplicationCable
  class Connection < ActionCable::Connection::Base
    include ApplicationHelper

    identified_by :current_user

    def connect
      self.current_user = find_verified_user
      logger.add_tags 'ActionCable', current_user.email
    end

    protected

    def find_verified_user # this checks whether a user is authenticated with devise
      begin
        if verified_user = env['warden'].user
          verified_user
        else

          reject_unauthorized_connection
        end
      rescue

      end
    end
  end
end
