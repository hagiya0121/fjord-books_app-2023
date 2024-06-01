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

  def extract_report_ids
    uris = URI.extract(content, %w[http https])
    pattern = %r{/reports/(\d+)}
    uris.map do |uri|
      uri = URI.parse(uri)
      pattern.match(uri.path).to_a[1].to_i if uri.host == TARGET_DOMAIN
    end
  end

  def update_mentioning_reports(report_ids)
    self.mentioning_reports = report_ids.map do |id|
      Report.find(id) if Report.exists?(id)
    end
  end
end
