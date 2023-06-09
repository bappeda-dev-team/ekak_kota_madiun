class CreateKomentars < ActiveRecord::Migration[6.1]
  def change
    create_table :komentars do |t|
      t.string :judul
      t.string :komentar
      t.string :kode_opd
      t.references :user, null: false, foreign_key: true
      t.bigint :item

      t.timestamps
    end
  end
end
