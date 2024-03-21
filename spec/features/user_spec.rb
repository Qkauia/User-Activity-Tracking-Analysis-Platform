require 'rails_helper'

RSpec.feature "User feature", type: :feature do

  describe "#devise" do
    let!(:user) { create(:user, email: "user@example.com", password: "password") }

    scenario 'user creates a new account' do
      visit new_user_registration_path

      fill_in '信箱', with: 'test@example.com'
      fill_in '密碼', with: 'password', match: :prefer_exact
      fill_in '確認輸入密碼', with: 'password', match: :prefer_exact
      fill_in '姓名', with: '艸先生'
      click_button '註冊'

      expect(page).to have_content('Welcome! You have signed up successfully.')
    end

    before(:each) do
      User.create!(email: 'test99@example.com', password: 'password', password_confirmation: 'password', name: "少先生")
    end

    scenario 'user login account' do
      visit root_path
      click_on '註冊 / 登入'
      expect(current_path).to eq(new_user_session_path)

      fill_in '信箱', with: 'test99@example.com'
      fill_in '密碼', with: 'password'
      click_button '登入'

      expect(page).to have_content('Signed in successfully.')
      expect(current_path).to eq(root_path)
    end

    scenario 'user navigates from login page to registration page and registers' do
      visit new_user_session_path

      click_on '註冊'
      expect(current_path).to eq(new_user_registration_path)
    end

    scenario 'user navigates from login page to forget password page' do
      visit new_user_session_path

      click_on '忘記密碼?'
      expect(current_path).to eq(new_user_password_path)
      
    end

    scenario "User requests a password reset" do
      visit new_user_password_path

      expect(page).to have_content("忘記密碼?")

      fill_in "Email", with: user.email

      click_button "發送重設密碼信件"

      expect(page).to have_content("You will receive an email with instructions on how to reset your password in a few minutes.")
      expect(current_path).to eq(new_user_session_path)
    end

    scenario "User change password" do

      login_as(user, scope: :user)
      visit edit_user_registration_path

      expect(page).to have_content("更改密碼")

      fill_in "信箱", with: user.email
      fill_in "姓名", with: user.name
      fill_in "密碼", with: user.password
      fill_in "確認密碼", with: user.password
      fill_in "確認舊密碼", with: user.password

      click_button "更新密碼"

      expect(page).to have_content("Your account has been updated successfully.")
      expect(current_path).to eq(root_path)
    end
  end

  describe "#index" do

    let!(:user) { create(:user)}
    let!(:activity) { create(:activity, user: user) }
    let!(:booking) { create(:booking, activity: activity, user: user) }
    let!(:log) { create(:log, activity: activity, user: user, booking: booking, type: 'submit')}

    scenario "Logged in" do
      login_as(user, scope: :user)
      visit users_path
      expect(page).to have_content("使用者活動")
      expect(page).to have_link(href: user_path(user))
      formatted_time = log.created_at.strftime("%Y 年 %m 月 %d 日 %H 點 %M 分")
      expected_content = "最後活動時間: #{formatted_time} 【 #{user.email} 】"
      expect(page).to have_content(expected_content)
    end

    scenario "not logged in" do
      visit users_path
      expect(page).to have_content("使用者活動")
      expect(page).to have_link(href: user_path(user))
      formatted_time = log.created_at.strftime("%Y 年 %m 月 %d 日 %H 點 %M 分")
      expected_content = "最後活動時間: #{formatted_time} 【 #{user.email} 】"
      expect(page).to have_content(expected_content)

    end
  end

  describe "#show" do

    let!(:user) { create(:user, admin: true)}
    let!(:user2) { create(:user)}
    let!(:activity) { create(:activity, user: user) }
    let!(:booking) { create(:booking, activity: activity, user: user) }
    let!(:booking) { create(:booking, activity: activity, user: user2) }
    let!(:logs) do
      [ 
        create(:log, user: user, type: 'submitted', created_at: 1.hour.ago),
        create(:log, user: user, type: 'login', created_at: 2.hour.ago),
        create(:log, user: user, type: 'browse_activity_show', created_at: 2.hour.ago),
        create(:log, user: user, type: 'email_field_changed', created_at: 2.hour.ago),
        create(:log, user: user, type: 'submitted', created_at: 2.hour.ago)
      ]
    end
    let!(:daily_date_range) { Time.zone.now.beginning_of_day..Time.zone.now.end_of_day }
    let!(:weekly_date_range) { Time.zone.today.beginning_of_week(:sunday)..Time.zone.today.end_of_day }
    
    let!(:daily_users_count) { Log.where(created_at: daily_date_range).distinct.count(:user_id) }
    let!(:weekly_users_count) { Log.where(created_at: weekly_date_range).distinct.count(:user_id) }
    
    let!(:daily_booking_total) { Log.booking_total_count(daily_date_range) }
    let!(:weekly_booking_total) { Log.booking_total_count(weekly_date_range) }
    
    let!(:booking_durations) { Log.booking_duration(daily_date_range) }
    let!(:average_duration) { Log.average_duration(booking_durations) }
    let!(:longest_duration) { Log.longest_duration(booking_durations) }
    let!(:percentile_99_duration) { Log.user_99th_percentile_duration(booking_durations) }
    
    let!(:average_seconds) { (average_duration * 60).round(2) }
    let!(:longest_seconds) { (longest_duration * 60).round(2) }

    scenario "Logged in (not admin) or not logged in" do
      login_as(user2, scope: :user)
      visit user_path(user)
      expect(current_path).to eq(root_path)
      expect(page).to have_content("你沒有權限")
    end

    scenario "Logged in (admin)" do
      login_as(user, scope: :user)
      visit user_path(user)

      expect(page).to have_content("使用者活動詳情")
      expect(page).to have_content("當日活耀使用者總數：共 #{daily_users_count} 位")
      expect(page).to have_content("當週活耀使用者總數：共 #{weekly_users_count} 位")

      expect(page).to have_content("當日活動報名總數：共 #{daily_booking_total} 筆")
      expect(page).to have_content("當週活動報名總數：共 #{weekly_booking_total} 筆")
      expect(page).to have_content("當日平均使用者預約所花費時間： #{average_duration} 分鐘 (#{average_seconds} 秒)")
      expect(page).to have_content("當日最長預約花費時間： #{longest_duration} 分鐘 (#{longest_seconds} 秒)")
      expect(page).to have_content("99%的用戶預約所花費時間 ： #{percentile_99_duration} 分鐘 (#{( percentile_99_duration * 60).round(2)} 秒)內")
      logs.each do |log|
        type_translation = I18n.t("type.#{log.type}")
        expect(page).to have_content(log.created_at.strftime('%Y 年 %m 月 %d 日 %H 點 %M 分 '))
        expect(page).to have_content("【 #{type_translation} 】")
      end

    end
  end

end