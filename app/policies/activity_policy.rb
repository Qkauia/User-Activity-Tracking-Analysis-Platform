# frozen_string_literal: true

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
    user.admin? || user.id == activity.user_id
  end

  def update?
    user.admin? || user.id == activity.user_id
  end

  def destroy?
    user.admin? || user.id == activity.user_id
  end

  def index?
    true
  end
end
