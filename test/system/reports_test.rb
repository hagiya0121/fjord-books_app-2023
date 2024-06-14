# frozen_string_literal: true

require 'application_system_test_case'

class ReportsTest < ApplicationSystemTestCase
  setup do
    @report = reports(:report_by_alice)
    visit root_url
    fill_in 'Eメール', with: 'alice@example.com'
    fill_in 'パスワード', with: 'password'
    click_button 'ログイン'
    assert_text 'ログインしました。'
  end

  test '日報の一覧を表示' do
    visit reports_url
    assert_selector 'h1', text: '日報の一覧'
  end

  test '日報を新規作成' do
    visit reports_url
    click_on '日報の新規作成'

    fill_in 'タイトル', with: 'Create new report'
    fill_in '内容', with: 'This is new report'
    click_on '登録する'

    assert_text '日報が作成されました。'
  end

  test '日報を更新' do
    visit report_url(@report)
    click_on 'この日報を編集'

    fill_in 'タイトル', with: @report.title
    fill_in '内容', with: @report.content
    click_on '更新する'

    assert_text '日報が更新されました。'
  end

  test '日報を削除' do
    visit report_url(@report)
    click_on 'この日報を削除'

    assert_text '日報が削除されました。'
  end
end
