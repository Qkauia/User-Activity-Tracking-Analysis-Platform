# frozen_string_literal: true

require 'rails_helper'
RSpec.feature 'Bookings feature', type: :feature do
  let!(:user) { create(:user) }
  let!(:user2) { create(:user) }
  let!(:activity) { create(:activity, user:) }
  let!(:activity2) { create(:activity, user:) }

  describe '#index' do
    scenario 'Unauthenticated User' do
      visit bookings_path

      expect(current_path).to eq(new_user_session_path)
      expect(page).to have_content('You need to sign in or sign up before continuing.')
    end

    scenario 'User singin (booked)' do
      login_as(user, scope: :user)
      booking1 = create(:booking, activity:, user:)
      booking2 = create(:booking, activity: activity2, user:)

      visit bookings_path
      expect(page).to have_content('已報名的活動')
      [booking1, booking2].each do |booking|
        expect(page).to have_link(href: booking_path(booking))
        expect(page).to have_content("活動標題：#{booking.activity.title}")
        expect(page).to have_content("活動簡介：#{booking.activity.description}")
        expect(page).to have_content("活動時間：#{booking.activity.start_time}")
        expect(page).to have_content("活動地點：#{booking.activity.location}")
      end

      find_link(href: booking_path(booking1)).click
      expect(current_path).to eq(booking_path(booking1))

      visit bookings_path

      find_link(href: booking_path(booking2)).click
      expect(current_path).to eq(booking_path(booking2))
    end

    scenario 'User signin(have no booked)' do
      login_as(user, scope: :user)

      visit bookings_path

      expect(page).to have_content('已報名的活動')
      expect(page).to have_content('沒有找到已預訂的活動。')
    end
  end

  describe '#show' do
    scenario 'Unauthenticated User' do
      booking = create(:booking, activity:, user:)
      visit booking_path(booking)

      expect(current_path).to eq(new_user_session_path)
      expect(page).to have_content('You need to sign in or sign up before continuing.')
    end

    scenario 'User signin(have no bookedor or a booking not belonging to oneself)' do
      booking = create(:booking, activity:, user: user2)
      login_as(user, scope: :user)
      visit booking_path(booking)

      expect(page.status_code).to eq(404)
      expect(page).to have_content("The page you were looking for doesn't exist.")
    end

    scenario "The current user's booking" do
      booking = create(:booking, activity:, user:)
      login_as(user, scope: :user)

      visit booking_path(booking)

      expect(page).to have_content('報名資訊')
      expect(page).to have_link(href: activity_booking_path(activity_id: booking.id, id: booking.id))

      expect(page).to have_content("活動主題：#{booking.activity.title}")
      expect(page).to have_content("主辦單位：#{booking.activity.organizer}")
      expect(page).to have_content("主辦人：#{booking.activity.user.name}")
      expect(page).to have_content("活動地點：#{booking.activity.location}")
      expect(page).to have_content("報名人數：#{booking.activity.bookings.count} / #{booking.activity.max_participants}")
      expect(page).to have_content("開始時間：#{booking.activity.start_time.strftime('%Y 年 %m 月 %d 日 %H 點 %M 分')} 至 #{booking.activity.end_time.strftime('%Y 年 %m 月 %d 日 %H 點 %M 分')}")
      expect(page).to have_content("詳細內容：#{booking.activity.description}")

      find_link(href: activity_booking_path(activity_id: booking.id, id: booking.id)).click
      expect(page).to have_content('報名已經取消')
    end
  end
end
