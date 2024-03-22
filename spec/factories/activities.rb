# frozen_string_literal: true

FactoryBot.define do
  factory :activity do
    title { '默默會' }
    description { '五倍學員聚聚' }
    start_time { Time.current + 1.day }
    end_time { 5.days.from_now }
    location { '五倍紅寶石' }
    max_participants { 20 }
    organizer { '艾瑞克集團' }
    user
  end
end
