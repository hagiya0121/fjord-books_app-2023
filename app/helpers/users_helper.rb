module UsersHelper
  def allowed_user?(user)
    current_user.id == user.id
  end
end
