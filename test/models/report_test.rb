# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  def setup
    @alice = users(:alice)
    @report_by_alice = reports(:report_by_alice)
    @report_by_bob = reports(:report_by_bob)
    @report_by_carol = reports(:report_by_carol)
    @report_by_alice.content = "http://localhost:3000/reports/#{@report_by_bob.id}"
    @report_by_alice.save
  end

  test '自分の日報を編集できる' do
    assert @report_by_alice.editable?(@alice)
  end

  test '他人の日報を編集できない' do
    assert_not @report_by_bob.editable?(@alice)
  end

  test '日報作成日時をDateオブジェクトに変換できる' do
    assert_instance_of Date, @report_by_alice.created_on
  end

  test 'メンションした日報が保存される' do
    assert_equal @report_by_bob, @report_by_alice.mentioning_reports.first
  end

  test '日報を更新してもメンションが保持される' do
    @report_by_alice.update(title: 'Updated Title')
    assert_equal @report_by_bob, @report_by_alice.mentioning_reports.first
  end

  test '日報更新時にメンションを追加できる' do
    @report_by_alice.content << "http://localhost:3000/reports/#{@report_by_carol.id}"
    @report_by_alice.update(title: 'Updated Title')
    assert_equal @report_by_carol, @report_by_alice.mentioning_reports.second
  end

  test '日報更新時にメンションを削除できる' do
    @report_by_alice.update(title: 'Updated Title', content: 'Updated Content')
    assert_not_includes @report_by_alice.reload.mentioning_reports, @report_by_bob
  end
end
