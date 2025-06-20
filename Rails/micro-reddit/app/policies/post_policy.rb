class PostPolicy < ApplicationPolicy
  # NOTE: Up to Pundit v2.3.1, the inheritance was declared as
  # `Scope < Scope` rather than `Scope < ApplicationPolicy::Scope`.
  # In most cases the behavior will be identical, but if updating existing
  # code, beware of possible changes to the ancestors:
  # https://gist.github.com/Burgestrand/4b4bc22f31c8a95c425fc0e30d7ef1f5

  class Scope < ApplicationPolicy::Scope
    # NOTE: Be explicit about which records you allow access to!
    # def resolve
    #   scope.all
    # end
  end

  def index?
    # Anyone can view the list of posts
    true
  end

  def show?
    true # Anyone can see a post
  end

  def create?
    # Only a logged-in user can create a post.
    # The `user` here comes from `current_user`. If not logged in, `user` is nil.
    user.present?
  end

  def update?
    # The user is the owner of the post
    # Guard clause: if there is no user, they can't update.
    return false unless user.present?

    # If a user is present, check if they are an admin or the owner.
    user.admin? || user == record.user
  end

  def edit?
    update? # Same rule as update
  end

  def destroy?
    # Guard clause: if there is no user, they can't destroy.
    return false unless user.present?
    # The user is the owner OR an admin
    user.admin? || user == record.user
  end
end
