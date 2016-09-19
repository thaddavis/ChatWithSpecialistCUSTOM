class DashboardPolicy < Struct.new(:user, :dashboard)

  def show?
    if user
      true
    else
      false
    end
  end

end
