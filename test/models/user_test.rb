# frozen_string_literal: true

require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @alice = users(:alice)
    @user_without_name = users(:user_without_name)
  end
  test 'name_or_email はユーザー名が設定されているときはその名前を返す' do
    assert_equal 'alice', @alice.name_or_email
  end

  test 'name_or_email はユーザー名が設定されていないときはメールアドレスを返す' do
    assert_equal 'user_without_name@example.com', @user_without_name.name_or_email
  end
end
