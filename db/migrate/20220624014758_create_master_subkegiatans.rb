class CreateMasterSubkegiatans < ActiveRecord::Migration[6.1]
  def change
    create_table :master_subkegiatans do |t|
      t.string :id_sub_kegiatan_sipd, null: true
      t.string :kode_sub_kegiatan, null: true
      t.string :tahun, default: Date.today.year
      t.string :id_urusan, null: true
      t.string :id_bidang_urusan, null: true
      t.string :nama_sub_kegiatan, default: '-'
      t.string :no_sub_kegiatan, null: true
      t.string :id_unik_sipd, null: false, unique: true
      t.string :id_program
      t.string :id_kegiatan
      t.timestamps

      t.index :id_unik_sipd, unique: true
    end
  end
end
