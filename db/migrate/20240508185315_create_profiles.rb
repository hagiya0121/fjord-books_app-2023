class CreateProfiles < ActiveRecord::Migration[7.0]
  def change
    create_table :profiles do |t|
      t.references :user, null: false, foreign_key: true
      t.string :postal_code
      t.string :address
      t.string :self_introduction

      t.timestamps
    end
  end
end
