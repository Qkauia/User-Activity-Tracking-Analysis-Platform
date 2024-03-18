# frozen_string_literal: true
# include FactoryBot::Syntax::Methods
require 'rails_helper'

RSpec.describe 'Users', type: :request do
  describe "GET /users" do
    let!(:user_with_recent_log) { create(:user) }
    let!(:user_with_older_log) { create(:user) }

    before do
      create(:log, user: user_with_recent_log, created_at: 1.day.ago, type: '送出表單')
      create(:log, user: user_with_older_log, created_at: 2.days.ago, type: '送出表單')
      get users_path, params: { format: :json }
    end

    it "responds successfully with an HTTP 200 status code" do
      expect(response).to have_http_status(:success)
    end

    it "returns all users in the correct order" do
      json_response = JSON.parse(response.body)
      ids = json_response.map { |user| user['id'] }
    
      expect(ids.last(2)).to eq([user_with_recent_log.id, user_with_older_log.id])
    end
  end
end
