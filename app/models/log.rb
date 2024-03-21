# frozen_string_literal: true

class Log < ApplicationRecord
  # 不使用 STI繼承
  self.inheritance_column = :_type_disabled

  belongs_to :user
  belongs_to :activity, optional: true
  belongs_to :booking, optional: true

  # 期間使用者活耀總數
  def self.date_range_active_users_total(date_range)
    where(created_at: date_range).distinct.count(:user_id)
  end

  # 期間使用者預約總數
  def self.booking_total_count(date_range)
    booking_total_count = 0

    where(created_at: date_range)
      .find_each do |log|
      if log.type == 'submitted'
        booking_total_count += 1
      elsif log.type == 'cancel_booking'
        booking_total_count -= 1
      end
    end
    booking_total_count
  end

  # 計算預約花費時間
  def self.booking_duration(date_range)
    all_logs = where(type: %w[browse_activity_show submitted], created_at: date_range).order(:created_at)
    # 資料分組
    preview_logs = all_logs.select { |log| log.type == 'browse_activity_show' }
    submit_logs = all_logs.select { |log| log.type == 'submitted' }
    # 創建新HASH(key對應id,value對應submit_logs Hash)
    new_submit_logs = submit_logs.index_by(&:id)
    # filter_map 結合了 filter 和 select 跟 map 的功能，回傳符合條件的值帶入新陣列
    preview_logs.filter_map do |preview_log|
      # # 找出new_submit_logs 的key(id)是否跟有預期 +2
      expected_submit_log_id = preview_log.id + 2
      submit_log = new_submit_logs[expected_submit_log_id]
      submit_log ? submit_log.created_at - preview_log.created_at : nil
    end
  end

  # 平均時長
  def self.average_duration(durations)
    return nil if durations.empty?
    (durations.sum / durations.size / 60).round(2)
  end

  # 最長時間篩選
  def self.longest_duration(durations)
    return nil if durations.empty?
    (durations.max / 60).round(2)
  end
  
  # 99%用戶booking操作時長
  def self.user_99th_percentile_duration(durations)
    return nil if durations.empty?
    sorted_durations = durations.sort
    index_99th = (sorted_durations.length * 0.99).floor - 1
    duration_in_min = sorted_durations[index_99th]
    (duration_in_min / 60 ).round(2)
  end

  # 使用 gem 'descriptive_statistics'
  # def self.user_99th_percentile_duration(durations)
  #   return nil if durations.empty?
  #   durations.extend(DescriptiveStatistics)
  #   percentile_99_duration = durations.percentile(99)
  #   (percentile_99_duration / 60).round(2)
  # end
  
end
