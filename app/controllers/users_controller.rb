class UsersController < ApplicationController

  after_action :verify_authorized

  layout "user_dashboard_layout"

  def show
    @user = User.find(params[:id])
    authorize @user
  end

  def destroy
    @user = User.find(params[:id])
    authorize @user
    @user.destroy
    redirect_to users_path, :notice => "User deleted"
  end

  def update
    @user = User.find(params[:id])

    authorize @user

    if @user.update_attributes(secure_params)
      redirect_to user_path, :notice => "User updated"
    else
      redirect_to users_path, :alert => "Unable to update"
    end
  end

  private
    def secure_params
      params.require(:user).permit(:email, :username, :first_name, :last_name)
    end

end
