# frozen_string_literal: true

module ApplicationHelper
  def format_datetime(date_time)
    date_time&.strftime('%Y 年 %m 月 %d 日 %H 點 %M 分 ')
  end
end
