class CreateMasterOutputKegiatans < ActiveRecord::Migration[6.1]
  def change
    create_table :master_output_kegiatans do |t|
      t.string :id_output_bl, null: false, unique: true
      t.string :id_bl
      t.string :id_skpd
      t.string :id_sub_skpd
      t.string :id_program
      t.string :id_kegiatan
      t.string :id_sub_kegiatan
      t.string :indikator_kegiatan
      t.string :target_kegiatan
      t.string :satuan_kegiatan
      t.string :indikator_sub_kegiatan
      t.string :target_sub_kegiatan
      t.string :satuan_sub_kegiatan
      t.string :tahun
      t.timestamps

      t.index :id_output_bl, unique: true
    end
  end
end
