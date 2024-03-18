FactoryBot.define do
  factory :activity do
    title { "默默會" }
    description { "五倍學員聚聚" }
    start_time { Time.zone.today }
    end_time { 5.days.since }
    location { "五倍紅寶石" }
    max_participants { 20 }
    organizer { "艾瑞克集團" }
    user
  end
end
