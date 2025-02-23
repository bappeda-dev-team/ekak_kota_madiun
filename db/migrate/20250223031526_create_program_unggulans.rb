class CreateProgramUnggulans < ActiveRecord::Migration[6.1]
  def change
    create_table :program_unggulans do |t|
      t.string :asta_karya
      t.string :tahun_awal
      t.string :tahun_akhir
      t.integer :urutan, default: 1
      t.string :keterangan
      t.references :lembaga, null: false, foreign_key: true

      t.timestamps
    end
  end
end
