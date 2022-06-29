class CreateMasterBidangUrusans < ActiveRecord::Migration[6.1]
  def change
    create_table :master_bidang_urusans do |t|
      t.string :id_bidang_urusan_sipd
      t.string :id_urusan
      t.string :tahun
      t.string :kode_bidang_urusan
      t.string :nama_bidang_urusan
      t.string :id_unik_sipd, null: false, unique: true
      t.timestamps

      t.index :id_unik_sipd, unique: true
    end
  end
end
