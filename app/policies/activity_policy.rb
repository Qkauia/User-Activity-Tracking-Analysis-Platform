class ActivityPolicy < ApplicationPolicy

  def new?
    user&.present?
  end

  def create?
    new?
  end

  def show?
    true
  end

  def edit?
    create?
  end

  def update?
    edit?
  end

  def destroy?
    update?
  end

  def index?
    true
  end

end
