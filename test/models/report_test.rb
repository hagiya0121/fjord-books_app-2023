# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  def setup
    @alice = users(:alice)
    @report_by_alice = reports(:report_by_alice)
    @report_by_bob = reports(:report_by_bob)
    @report_by_carol = reports(:report_by_carol)
    @report_by_dave = reports(:report_by_dave)
    @report_by_alice.content = "http://localhost:3000/reports/#{@report_by_bob.id}
                                http://localhost:3000/reports/#{@report_by_carol.id}"
    @report_by_alice.save
  end

  test '自分の日報を編集できる' do
    assert @report_by_alice.editable?(@alice)
  end

  test '他人の日報を編集できない' do
    assert_not @report_by_bob.editable?(@alice)
  end

  test '日報作成日時をDateオブジェクトに変換できる' do
    @report_by_alice.created_at = '2024-06-12 15:23:13 +0900'
    assert_equal '2024-06-12', @report_by_alice.created_on.to_s
  end

  test 'メンションした日報が保存される' do
    assert_includes @report_by_alice.mentioning_reports, @report_by_bob
    assert_includes @report_by_alice.mentioning_reports, @report_by_carol
  end

  test '日報更新時にメンションを保持、追加、削除できる' do
    @report_by_alice.content = "http://localhost:3000/reports/#{@report_by_bob.id}
                                http://localhost:3000/reports/#{@report_by_dave.id}}"
    @report_by_alice.update(title: 'Updated Title')
    assert_includes @report_by_alice.mentioning_reports, @report_by_bob
    assert_includes @report_by_alice.mentioning_reports, @report_by_dave
    assert_not_includes @report_by_alice.reload.mentioning_reports, @report_by_carol
  end
end
