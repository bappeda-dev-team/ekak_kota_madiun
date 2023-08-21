class CreateTims < ActiveRecord::Migration[6.1]
  def change
    create_table :tims do |t|
      t.string :nama_tim
      t.string :nip
      t.string :jabatan
      t.string :jenis
      t.bigint :team_ref_id
      t.string :tahun
      t.string :keterangan
      t.references :opd, null: true

      t.timestamps
    end
  end
end
