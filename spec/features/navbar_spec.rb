require 'rails_helper'

RSpec.feature "Navbars", type: :feature do

  scenario "nonmember or User is not logged in" do
    visit current_path
    expect(page).to have_link('註冊 / 登入', href: new_user_session_path)
    expect(page).to have_link('學習王', href: root_path)
    expect(page).not_to have_link('登出')
    expect(page).not_to have_link('更改密碼')
    expect(page).not_to have_link('建立活動')
    expect(page).not_to have_link('我參加的活動')
    expect(page).not_to have_link('追蹤使用者')

    click_link '學習王'
    expect(current_path).to eq(root_path)

    click_link '註冊 / 登入'
    expect(current_path).to eq(new_user_session_path)
  end

  scenario "user login" do
    user = FactoryBot.create(:user, name: "Test User", email: "test@example.com")
  
    login_as(user, scope: :user)
    visit current_path
  
    expect(page).to have_content("Test User (test@example.com)")
    expect(page).to have_content("Test User (test@example.com)")
    expect(page).to have_link('學習王', href: root_path)
    expect(page).to have_link('登出', href: destroy_user_session_path)
    expect(page).to have_link('更改密碼', href: edit_user_registration_path)
    expect(page).to have_link('建立活動', href: new_activity_path)
    expect(page).to have_link('我參加的活動', href: bookings_path)
    expect(page).to have_link('追蹤使用者', href: users_path)
    expect(page).not_to have_link('註冊 / 登入', href: new_user_session_path)
  
    click_link '學習王'
    expect(current_path).to eq(root_path)
  
    click_link '更改密碼'
    expect(current_path).to eq(edit_user_registration_path)
  
    click_link '建立活動'
    expect(current_path).to eq(new_activity_path)
  
    click_link '我參加的活動'
    expect(current_path).to eq(bookings_path)
    
    click_link '追蹤使用者'
    expect(current_path).to eq(users_path)

    click_link '登出'
    expect(current_path).to eq(root_path)
    expect(page).to have_content('Signed out successfully.')
  end
end
