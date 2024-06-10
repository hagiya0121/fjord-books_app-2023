class CreateMentionReports < ActiveRecord::Migration[7.0]
  def change
    create_table :mention_reports do |t|
      t.references :mentioning_report, null: false, foreign_key: {to_table: :reports}
      t.references :mentioned_report, null: false, foreign_key: {to_table: :reports}

      t.timestamps
    end
    add_index :mention_reports, [:mentioning_report_id, :mentioned_report_id], unique: true, name: 'unique_index_on_mention_reports'
  end
end
