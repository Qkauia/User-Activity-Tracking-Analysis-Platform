# frozen_string_literal: true

class ApplicationPolicy
  attr_reader :user, :activity, :record

  def initialize(user, record)
    @user = user
    @activity = activity
    @record = record
  end
end
