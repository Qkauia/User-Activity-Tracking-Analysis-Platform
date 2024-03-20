# frozen_string_literal: true

rails_env = ENV['RAILS_ENV'] || :development
set :environment, rails_env
set :output, "log/cron_log.log"
env :PATH, ENV['PATH']

every :day, at: '8:00' do
  runner 'SummaryMailer.send_daily_summaries'
end

every :monday, at: '8:00' do
  runner 'SummaryMailer.send_weekly_summaries'
end

every :sunday, at: '4:30' do
  runner 'CleanOldLogsJob.perform_later'
end

#  bundle exec sidekiq
