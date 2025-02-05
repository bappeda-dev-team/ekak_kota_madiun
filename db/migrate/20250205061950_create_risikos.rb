class CreateRisikos < ActiveRecord::Migration[6.1]
  def change
    create_table :risikos do |t|
      t.string :konteks_strategis
      t.string :prioritas
      t.string :tahun_penilaian
      t.references :tujuan_kota, null: false, foreign_key: true

      t.timestamps
    end
  end
end
