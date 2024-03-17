# frozen_string_literal: true

module ApplicationHelper
  def format_datetime(date_time)
    date_time&.strftime('%Y年%m月%d日 (%H:%M:%S)')
  end
end
