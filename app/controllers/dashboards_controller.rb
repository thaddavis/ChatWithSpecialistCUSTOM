class DashboardsController < ApplicationController

  after_action :verify_authorized

  layout "user_dashboard_layout"

  def show
    authorize :dashboard, :show?
  end

end
