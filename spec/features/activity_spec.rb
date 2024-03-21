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
    let!(:activity) { create(:activity, user: user) }
    let!(:user) { create(:user)}

    scenario "nonmember or User is not logged in tries to book an activity" do
      
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

    scenario "if User have activity" do
      
      FactoryBot.create(:booking, activity: activity, user: user)
  
      login_as(user, scope: :user)
  
      visit activity_path(activity)
      
      expect(page).to have_link('修改活動內容', href: edit_activity_path(activity))
      expect(page).to have_link('刪除活動', href: activity_path(activity))
      expect(page).to have_content("活動主題：#{activity.title}")
      expect(page).to have_content("主辦單位：#{activity.organizer}")
      expect(page).to have_content("活動地點：#{activity.location}")
      expect(page).to have_content("報名人數：#{activity.bookings.count} / #{activity.max_participants}")
      expect(page).to have_content("開始時間：#{activity.start_time.strftime('%Y 年 %m 月 %d 日 %H 點 %M 分')} 至 #{activity.end_time.strftime('%Y 年 %m 月 %d 日 %H 點 %M 分')}")
      expect(page).to have_content("詳細內容：#{activity.description}")
      
      click_link '修改活動內容'
      expect(current_path).to eq(edit_activity_path(activity))

      visit activity_path(activity)
      click_link '刪除活動'
      expect(current_path).to eq(activities_path)
      expect(page).to have_content('活動已經刪除')
    end
  
    # (已經參加過))不能再報名
    scenario "user booked an activity" do
      
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

    scenario "nonmember or User is not logged in" do
      visit new_activity_path
      expect(current_path).to eq(root_path)
      expect(page).to have_content('你沒有權限')
    end
  
    scenario "User creates a new activity" do
      
      user = FactoryBot.create(:user)
      login_as(user, scope: :user)
  
      visit new_activity_path
  
      fill_in '活動標題', with: '新活動'
      fill_in '活動介紹', with: '這是一個很棒的活動'
      fill_in '活動開始時間', with: '2023-01-01T10:00'
      fill_in '活動結束時間', with: '2023-01-01T12:00'
      fill_in '活動地點', with: '五倍紅寶石'
      fill_in '人數限制', with: '50'
      fill_in '活動單位', with: '組織者'
  
      click_button 'Create Activity'
      expect(current_path).to eq(activities_path)
      expect(page).to have_content('活動建立成功')
      expect(page).to have_content('新活動')
      expect(page).to have_content('這是一個很棒的活動')
  
      # 欄位必填
      visit new_activity_path
  
      fill_in '活動標題', with: ''
      fill_in '活動介紹', with: ''
      fill_in '活動開始時間', with: ''
      fill_in '活動結束時間', with: ''
      fill_in '活動地點', with: ''
      fill_in '人數限制', with: ''
      fill_in '活動單位', with: ''
  
      click_button 'Create Activity'
      expect(page).to have_content('8 errors必需填寫:')
      
      # 活動開始時間必須 < 活動結束時間
      visit new_activity_path
      
      fill_in '活動標題', with: '新活動'
      fill_in '活動介紹', with: '這是一個很棒的活動'
      fill_in '活動開始時間', with: '2023-03-23T10:00'
      fill_in '活動結束時間', with: '2023-03-22T12:00'
      fill_in '活動地點', with: '五倍紅寶石'
      fill_in '人數限制', with: '50'
      fill_in '活動單位', with: '組織者'
      click_button 'Create Activity'
      expect(page).to have_content('1 error必需填寫')
      expect(page).to have_content('End time 必須晚於開始時間')
      
    end
  end

  describe '#edit' do

    let!(:user) { create(:user)}
    let!(:activity) { create(:activity, user: user) }

    scenario "nonmember or User is not logged in" do
      visit edit_activity_path(activity)
      expect(current_path).to eq(root_path)
      expect(page).to have_content('你沒有權限')
    end
  
    scenario "User edit activity" do
      
      login_as(user, scope: :user)
  
      visit edit_activity_path(activity)
      
      fill_in '活動標題', with: '新活動'
      fill_in '活動介紹', with: '這是一個很棒的活動'
      fill_in '活動開始時間', with: '2023-01-01T10:00'
      fill_in '活動結束時間', with: '2023-03-01T12:00'
      fill_in '活動地點', with: '五倍紅寶石'
      fill_in '人數限制', with: '50'
      fill_in '活動單位', with: '組織者'
      
      click_button 'Update Activity'
      expect(current_path).to eq(activity_path(activity))
      expect(page).to have_content('活動更新成功')
  
      # 欄位必填
      visit edit_activity_path(activity)
  
      fill_in '活動標題', with: ''
      fill_in '活動介紹', with: ''
      fill_in '活動開始時間', with: ''
      fill_in '活動結束時間', with: ''
      fill_in '活動地點', with: ''
      fill_in '人數限制', with: ''
      fill_in '活動單位', with: ''
  
      click_button 'Update Activity'
      expect(page).to have_content('8 errors必需填寫:')
      
      # 活動開始時間必須 < 活動結束時間
      visit edit_activity_path(activity)
      
      fill_in '活動標題', with: '新活動'
      fill_in '活動介紹', with: '這是一個很棒的活動'
      fill_in '活動開始時間', with: '2023-03-23T10:00'
      fill_in '活動結束時間', with: '2023-03-22T12:00'
      fill_in '活動地點', with: '五倍紅寶石'
      fill_in '人數限制', with: '50'
      fill_in '活動單位', with: '組織者'
      click_button 'Update Activity'
      expect(page).to have_content('1 error必需填寫')
      expect(page).to have_content('End time 必須晚於開始時間')
      
    end
  end

  
end
