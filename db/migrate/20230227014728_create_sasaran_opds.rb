class CreateSasaranOpds < ActiveRecord::Migration[6.1]
  def change
    create_table :sasaran_opds do |t|
      t.string :id_tujuan
      t.string :id_sasaran
      t.string :tahun_awal
      t.string :tahun_akhir
      t.string :sasaran, null: false
      t.string :kode_unik_opd, null: false
      t.timestamps
    end
  end
end
