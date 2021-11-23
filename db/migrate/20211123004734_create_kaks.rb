class CreateKaks < ActiveRecord::Migration[6.1]
  def change
    create_table :kaks do |t|
      t.text :dasar_hukum
      t.text :tujuan
      t.text :sasaran_kinerja
      t.text :indikator_kinerja
      t.string :target
      t.string :satuan
      t.string :penerima_manfaat
      t.text :data_terpilah
      t.text :akses
      t.text :partisipasi
      t.text :kontrol
      t.text :manfaat
      t.text :penyebab_internal
      t.text :penyebab_external
      t.text :permasalahan_umum
      t.text :permasalahan_gender
      t.text :resiko
      t.string :lokasi_pelaksanaan

      t.timestamps
    end
  end
end
