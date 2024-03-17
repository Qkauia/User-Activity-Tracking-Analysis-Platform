class BookingPolicy < ApplicationPolicy
  
  def create?
    user.present?
  end

  def index?
    booking.present? && user.id == booking.user_id
  end

  def destroy?
    booking.present? && user.id == booking.user_id
  end

end
