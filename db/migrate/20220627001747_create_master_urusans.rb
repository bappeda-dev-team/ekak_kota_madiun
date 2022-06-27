class CreateMasterUrusans < ActiveRecord::Migration[6.1]
  def change
    create_table :master_urusans do |t|
      t.string :id_urusan_sipd
      t.string :id_unik_sipd, null: false, unique: true
      t.string :tahun
      t.string :kode_urusan
      t.string :nama_urusan, null: true
      t.timestamps

      t.index :id_unik_sipd, unique: true
    end
  end
end
