class RemoveKakOldAttributes < ActiveRecord::Migration[6.1]
  def change
    change_table :kaks do |t|
      t.remove :dasar_hukum
      t.remove :tujuan
      t.remove :penerima_manfaat
      t.remove :data_terpilah
      t.remove :akses
      t.remove :partisipasi
      t.remove :kontrol
      t.remove :manfaat
      t.remove :penyebab_internal
      t.remove :penyebab_external
      t.remove :permasalahan_umum
      t.remove :permasalahan_gender
      t.remove :resiko
      t.remove :lokasi_pelaksanaan
      t.references :user
    end
  end
  
end
