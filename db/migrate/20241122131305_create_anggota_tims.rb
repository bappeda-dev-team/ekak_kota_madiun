class CreateAnggotaTims < ActiveRecord::Migration[6.1]
  def change
    create_table :anggota_tims do |t|
      t.string :nama
      t.string :role
      t.string :keterangan
      t.string :tahun
      t.jsonb :metadata
      t.references :tim, null: false, foreign_key: true

      t.timestamps
    end
  end
end
