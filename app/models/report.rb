# frozen_string_literal: true

class Report < ApplicationRecord
  belongs_to :user
  has_many :comments, as: :commentable, dependent: :destroy

  has_many :active_mentions,
           foreign_key: :mentioning_report_id,
           class_name: 'MentionReport',
           dependent: :destroy,
           inverse_of: :mentioning_report

  has_many :mentioned_reports,
           through: :active_mentions,
           source: :mentioned_report,
           dependent: :destroy

  has_many :passive_mentions,
           foreign_key: :mentioned_report_id,
           class_name: 'MentionReport',
           dependent: :destroy,
           inverse_of: :mentioned_report

  has_many :mentioning_reports,
           through: :passive_mentions,
           source: :mentioning_report,
           dependent: :destroy

  validates :title, presence: true
  validates :content, presence: true

  def editable?(target_user)
    user == target_user
  end

  def created_on
    created_at.to_date
  end

  TARGET_DOMAIN = 'localhost'

  def update_mentioning_reports
    uris = URI.extract(content, %w[http https])
    pattern = %r{/reports/(\d+)}
    report_ids = uris.map do |uri|
      uri = URI.parse(uri)
      pattern.match(uri.path).to_a[1].to_i if uri.host == TARGET_DOMAIN
    end.uniq
    self.mentioning_reports = Report.where(id: report_ids)
  end

  def save_with_report_update(params = {})
    ActiveRecord::Base.transaction do
      params.empty? ? save! : update!(params)
      update_mentioning_reports
    end
  rescue ActiveRecord::RecordInvalid
    false
  end
end
