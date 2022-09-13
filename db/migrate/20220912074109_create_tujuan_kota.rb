class CreateTujuanKota < ActiveRecord::Migration[6.1]
  def change
    create_table :tujuan_kota do |t|
      t.string :id_misi
      t.string :tahun_awal
      t.string :tahun_akhir
      t.string :id_tujuan
      t.string :visi
      t.string :misi
      t.string :tujuan
      t.string :type

      t.timestamps

      t.index :id_tujuan, unique: true
    end
  end
end
