class PaymentProfilePolicy < ApplicationPolicy

  def show?
    @model.user_id == @current_user.id
  end

  def edit?
    @model.user_id == @current_user.id
  end

  def update?
    @model.user_id == @current_user.id
  end

  def destroy?
    @model.user_id == @current_user.id
  end

  def add_card?
    @model.user_id == @current_user.id
  end

  def remove_card?
    @model.user_id == @current_user.id
  end

  def set_default_card?
    @model.user_id == @current_user.id
  end

  def switch_plan?
    @model.user_id == @current_user.id
  end

end
