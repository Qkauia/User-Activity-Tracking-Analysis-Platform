# frozen_string_literal: true

class CleanOldLogsJob < ApplicationJob
  queue_as :default

  def perform(*_args)
    Log.where('created_at < ?', 9.days.ago).delete_all
  end
end
