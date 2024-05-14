class CreatePendidikans < ActiveRecord::Migration[6.1]
  def change
    create_table :pendidikans do |t|
      t.integer :jumlah
      t.string :keterangan
      t.string :pendidikan
      t.string :tahun
      t.references :jabatan, null: false, foreign_key: true

      t.timestamps
    end
  end
end
