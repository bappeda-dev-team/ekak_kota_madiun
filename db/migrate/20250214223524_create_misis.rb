class CreateMisis < ActiveRecord::Migration[6.1]
  def change
    create_table :misis do |t|
      t.string :misi
      t.integer :urutan, default: 1
      t.string :keterangan
      t.string :tahun_awal
      t.string :tahun_akhir
      t.references :visi, null: false, foreign_key: true

      t.timestamps
    end
  end
end
