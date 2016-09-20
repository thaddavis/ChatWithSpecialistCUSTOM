class DashboardsController < ApplicationController

  after_action :verify_authorized

  layout "user_dashboard_layout"

  def show
    authorize :dashboard, :show?

    @num_of_chats = Chat.all.count
    @num_of_comments = Message.all.count

  end

end
