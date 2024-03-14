# frozen_string_literal: true

require 'test_helper'

class BookingControllerTest < ActionDispatch::IntegrationTest
  test 'should get create' do
    get booking_create_url
    assert_response :success
  end

  test 'should get destroy' do
    get booking_destroy_url
    assert_response :success
  end

  test 'should get index' do
    get booking_index_url
    assert_response :success
  end
end
