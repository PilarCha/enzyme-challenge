# frozen_string_literal: true

require 'test_helper'

class DistanceControllerTest < ActionDispatch::IntegrationTest
  test 'should get index' do
    get distance_index_url
    assert_response :success
  end
end
