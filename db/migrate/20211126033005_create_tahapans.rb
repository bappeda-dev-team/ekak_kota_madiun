class CreateTahapans < ActiveRecord::Migration[6.1]
  def change
    create_table :tahapans do |t|
      t.string :tahapan_kerja
      t.int :target
      t.int :realisasi
      t.string :bulan
      t.int :jumlah_target
      t.int :jumlah_realisasi
      t.string :keterangan
      t.int :waktu
      t.int :progress

      t.timestamps
    end
  end
end
