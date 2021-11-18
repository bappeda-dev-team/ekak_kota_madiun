class CreateProgramKegiatans < ActiveRecord::Migration[6.1]
  def change
    create_table :program_kegiatans do |t|
      t.string :nama_program
      t.string :nama_kegiatan
      t.string :nama_subkegiatan
      t.string :indikator_kinerja
      t.string :target
      t.string :satuan

      t.timestamps
    end
  end
end
