class UserPolicy < ApplicationPolicy

  def index?
    @current_user.admin?
  end

  def show?
    @current_user == @model
  end

  def update?
    @current_user == @model
  end

  def destroy?
    @current_user == @model
  end

end
