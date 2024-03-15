# frozen_string_literal: true

# every :day, at: '8:00 am' do
#   runner 'SummaryMailer.send_daily_summary'
# end

# every :monday, at: '8:00 am' do
#   runner 'SummaryMailer.send_weekly_summary'
# end

every 1.minutes do
  runner "SummaryMailer.daily_summary('kauia96@gmail.com').deliver_later"
end

every 1.minutes do
  runner "SummaryMailer.send_weekly_summary"
end

