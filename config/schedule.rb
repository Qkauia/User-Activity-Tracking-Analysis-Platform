# frozen_string_literal: true

every :day, at: '8:00 am' do
  runner 'SummaryMailer.send_daily_summary'
end

every :monday, at: '8:00 am' do
  runner 'SummaryMailer.send_weekly_summary'
end
