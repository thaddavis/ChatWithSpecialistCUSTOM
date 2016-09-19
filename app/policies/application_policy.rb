class ApplicationPolicy
  attr_reader :user, :model

  def initialize(current_user, model)
    raise Pundit::NotAuthorizedError, "must be logged in" unless current_user
    @current_user = current_user
    @model = model
  end

end
