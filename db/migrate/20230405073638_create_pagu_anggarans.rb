class CreatePaguAnggarans < ActiveRecord::Migration[6.1]
  def change
    create_table :pagu_anggarans do |t|
      t.string :tahun
      t.string :kode
      t.string :kode_opd
      t.string :jenis
      t.string :sub_jenis
      t.decimal :anggaran
      t.string :kode_belanja
      t.string :kode_sub_belanja
      t.string :keterangan

      t.timestamps
    end
  end
end
