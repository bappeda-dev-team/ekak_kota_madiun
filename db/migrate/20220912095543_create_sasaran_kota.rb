class CreateSasaranKota < ActiveRecord::Migration[6.1]
  def change
    create_table :sasaran_kota do |t|
      t.string :id_misi
      t.string :id_tujuan
      t.string :id_sasaran
      t.string :tahun_awal
      t.string :tahun_akhir
      t.string :visi
      t.string :misi
      t.string :tujuan
      t.string :sasaran

      t.timestamps

      t.index :id_sasaran, unique: true
    end
  end
end
