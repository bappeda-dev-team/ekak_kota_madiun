class CreateTaggingAnggarans < ActiveRecord::Migration[6.1]
  def change
    create_table :tagging_anggarans do |t|
      t.string :tagging
      t.references :anggaran, null: false, foreign_key: true

      t.timestamps
    end
  end
end
