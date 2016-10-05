class ApplicationController < ActionController::Base
  include ApplicationHelper
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
end
