require 'rails_helper'

RSpec.feature "Activity feature", type: :feature do
  describe "#index" do
    let!(:activity1) { create(:activity, title: "默默會一", description: "五倍學員聚聚一", start_time: 1.day.from_now, location: "地點一") }
    let!(:activity2) { create(:activity, title: "默默會二", description: "五倍學員聚聚二", start_time: 2.days.from_now, location: "地點二") }
    scenario "users can view a list of activities and navigate to their details" do
      
      visit activities_path
  
      expect(page).to have_content("活動一覽")
      [activity1, activity2].each do |activity|
        expect(page).to have_link(href: activity_path(activity))
        expect(page).to have_content("活動標題：#{activity.title}")
        expect(page).to have_content("活動簡介：#{activity.description}")
        expect(page).to have_content("活動時間：#{activity.start_time.strftime('%Y-%m-%d %H:%M')}")
        expect(page).to have_content("活動地點：#{activity.location}")
      end
  
      find_link(href: activity_path(activity1)).click
      expect(current_path).to eq(activity_path(activity1))
      expect(page).to have_content(activity1.title)
      expect(page).to have_content(activity1.description)
  
      visit activities_path
  
      find_link(href: activity_path(activity2)).click
      expect(current_path).to eq(activity_path(activity2))
      expect(page).to have_content(activity2.title)
      expect(page).to have_content(activity2.description)
    end
  end

  describe "#show" do
    # 訪客 / 未登入
    scenario "nonmember or User is not logged in tries to book an activity" do

      activity = FactoryBot.create(:activity)
      
      user = FactoryBot.create(:user)
      FactoryBot.create(:booking, activity: activity, user: user)
  
      expect(activity.bookings.count).to eq(1)
      expect(activity.max_participants).to eq(20)
  
      visit activity_path(activity)
  
      expect(page).to have_content("活動主題：#{activity.title}")
      expect(page).to have_content("主辦單位：#{activity.organizer}")
      expect(page).to have_content("活動地點：#{activity.location}")
      expect(page).to have_content("報名人數：#{activity.bookings.count} / #{activity.max_participants}")
      expect(page).to have_content("開始時間：#{activity.start_time.strftime('%Y 年 %m 月 %d 日 %H 點 %M 分')} 至 #{activity.end_time.strftime('%Y 年 %m 月 %d 日 %H 點 %M 分')}")
      expect(page).to have_content("詳細內容：#{activity.description}")
  
      fill_in '報名者姓名：', with: '艸先生2'
      fill_in '報名者信箱', with: 'test2@example.com'
      
      click_button '參加活動'
      expect(current_path).to eq(new_user_session_path)
      expect(page).to have_content('You need to sign in or sign up before continuing.')
    end
  
    #(已經參加過))已經登入，可以看到活動資訊跟預約表單，送出後會轉到activity show，顯示 '報名成功'
    scenario "user booked an activity" do
      user = FactoryBot.create(:user)
      activity = FactoryBot.create(:activity)
      FactoryBot.create(:booking, activity: activity, user: user)
  
      expect(activity.bookings.count).to eq(1)
      expect(activity.max_participants).to eq(20)
  
      login_as(user, scope: :user)
      allow_any_instance_of(User).to receive(:already_booked?).with(activity).and_return(false)
      
      visit activity_path(activity)
      
      expect(page).to have_content("活動主題：#{activity.title}")
      expect(page).to have_content("主辦單位：#{activity.organizer}")
      expect(page).to have_content("活動地點：#{activity.location}")
      expect(page).to have_content("報名人數：#{activity.bookings.count} / #{activity.max_participants}")
      expect(page).to have_content("開始時間：#{activity.start_time.strftime('%Y 年 %m 月 %d 日 %H 點 %M 分')} 至 #{activity.end_time.strftime('%Y 年 %m 月 %d 日 %H 點 %M 分')}")
      expect(page).to have_content("詳細內容：#{activity.description}")
  
    end

    scenario "user books an activity" do
      user = FactoryBot.create(:user)
      activity = FactoryBot.create(:activity)
  
      expect(activity.bookings.count).to eq(0)
      expect(activity.max_participants).to eq(20)
  
      login_as(user, scope: :user)
      allow_any_instance_of(User).to receive(:already_booked?).with(activity).and_return(false)
      
      visit activity_path(activity)
      
      expect(page).to have_content("活動主題：#{activity.title}")
      expect(page).to have_content("主辦單位：#{activity.organizer}")
      expect(page).to have_content("活動地點：#{activity.location}")
      expect(page).to have_content("報名人數：#{activity.bookings.count} / #{activity.max_participants}")
      expect(page).to have_content("開始時間：#{activity.start_time.strftime('%Y 年 %m 月 %d 日 %H 點 %M 分')} 至 #{activity.end_time.strftime('%Y 年 %m 月 %d 日 %H 點 %M 分')}")
      expect(page).to have_content("詳細內容：#{activity.description}")
  
      fill_in '報名者姓名：', with: '艸先生'
      fill_in '報名者信箱', with: 'test@test.com'
      
      click_button '參加活動'
      expect(current_path).to eq(activity_path(activity))
      expect(page).to have_content('報名成功')
    end
  end

  describe '#new' do
    scenario "users can view a list of activities and navigate to their details" do
      activity1 = FactoryBot.create(:activity, title: "默默會一", description: "五倍學員聚聚一", start_time: 1.day.from_now, location: "地點一")
      activity2 = FactoryBot.create(:activity, title: "默默會二", description: "五倍學員聚聚二", start_time: 2.days.from_now, location: "地點二")
  
      visit activities_path
  
      expect(page).to have_content("活動一覽")
      [activity1, activity2].each do |activity|
        expect(page).to have_link(href: activity_path(activity))
        expect(page).to have_content("活動標題：#{activity.title}")
        expect(page).to have_content("活動簡介：#{activity.description}")
        expect(page).to have_content("活動時間：#{activity.start_time.strftime('%Y-%m-%d %H:%M')}")
        expect(page).to have_content("活動地點：#{activity.location}")
      end
  
      find_link(href: activity_path(activity1)).click
      expect(current_path).to eq(activity_path(activity1))
      expect(page).to have_content(activity1.title)
      expect(page).to have_content(activity1.description)
  
      visit activities_path
  
      find_link(href: activity_path(activity2)).click
      expect(current_path).to eq(activity_path(activity2))
      expect(page).to have_content(activity2.title)
      expect(page).to have_content(activity2.description)
    end
  end

  
end
