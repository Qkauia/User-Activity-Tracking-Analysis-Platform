# frozen_string_literal: true

class Log < ApplicationRecord
  # 不使用 STI繼承
  self.inheritance_column = :_type_disabled

  belongs_to :user
  belongs_to :activity, optional: true
  belongs_to :booking, optional: true

end
