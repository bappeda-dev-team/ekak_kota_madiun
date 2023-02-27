class CreateManualIks < ActiveRecord::Migration[6.1]
  def change
    create_table :manual_iks do |t|
      t.string :perspektif
      t.string :rhk
      t.string :tujuan_rhk
      t.string :indikator_kinerja
      t.string :target
      t.string :satuan
      t.string :definisi
      t.string :key_activities
      t.string :key_milestone
      t.string :formula
      t.string :jenis_indikator
      t.string :penanggung_jawab
      t.string :penyedia_data
      t.string :sumber_data
      t.string :mulai
      t.string :akhir
      t.string :periode_pelaporan
      t.string :budget
      t.string :indikator_sasaran_id

      t.timestamps
    end
  end
end
