# frozen_string_literal: true

require 'test_helper'

class ReportTest < ActiveSupport::TestCase
  def setup
    @alice = users(:alice)
    @report_by_alice = reports(:report_by_alice)
    @report_by_bob = reports(:report_by_bob)
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
end
