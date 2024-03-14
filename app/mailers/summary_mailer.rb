# frozen_string_literal: true

class SummaryMailer < ApplicationMailer
  def self.send_daily_summary
    User.where(admin: true).find_each do |admin|
      daily_summary(admin.email).deliver_later
    end
  end

  def self.send_weekly_summary
    User.where(admin: true).find_each do |admin|
      weekly_summary(admin.email).deliver_later
    end
  end

  def daily_summary(admin_email)
    @time_now = Time.now.strftime('%Y-%m-%d %H:%M')
    mail(to: admin_email, subject: 'Hello!◎學習王每日摘要◎')
  end

  def weekly_summary(admin_email)
    @time_now = Time.now.strftime('%Y-%m-%d %H:%M')
    mail(to: admin_email, subject: 'Hello!◎學習王每週摘要◎')
  end
end
