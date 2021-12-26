class CreateHukums < ActiveRecord::Migration[6.1]
  def change
    create_table :hukums do |t|
      t.text :dasar_hukum
      t.references :kak, null: false, foreign_key: true

      t.timestamps
    end
  end
end
