class CleanOldLogsJob < ApplicationJob
  queue_as :default

  def perform(*args)
    Log.where('created_at < ?', 9.days.ago).delete_all
  end
end
