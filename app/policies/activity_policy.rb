class ActivityPolicy < ApplicationPolicy

  def new?
    user.present?
  end

  def create?
    new?
  end

  def show?
    true
  end

  def edit?
    activity.present? && user.id == activity.user_id
  end

  def update?
    activity.present? && user.id == activity.user_id
  end

  def destroy?
    activity.present? && user.id == activity.user_id
  end

  def index?
    true
  end

end
