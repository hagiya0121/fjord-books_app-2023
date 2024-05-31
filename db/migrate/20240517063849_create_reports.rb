class CreateReports < ActiveRecord::Migration[7.0]
  def change
    create_table :reports do |t|
      t.string :title
      t.text :text

      t.timestamps
    end
    add_reference :reports, :user, null: false, foreign_key: true
  end
end
