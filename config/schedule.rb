# frozen_string_literal: true

every :day, at: '8:00 am' do
  runner 'SummaryMailer.send_daily_summary'
end

every :monday, at: '8:00 am' do
  runner 'SummaryMailer.send_weekly_summary'
end

every :sunday, at: '4:30 am' do
  runner 'CleanOldLogsJob.perform_later'
end

#  bundle exec sidekiq
