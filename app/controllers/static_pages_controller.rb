class StaticPagesController < ApplicationController

  skip_before_action :authenticate_user!

  def home
    if (current_user)
      redirect_to dashboard_path
    end
  end

  def help
  end

  def about
  end

end
