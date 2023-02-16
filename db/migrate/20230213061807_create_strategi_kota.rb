class CreateStrategiKota < ActiveRecord::Migration[6.1]
  def change
    create_table :strategi_kota do |t|
      t.string :strategi
      t.string :tahun
      t.string :sasaran_kota_id
      t.string :isu_strategis_kota_id

      t.timestamps
    end
  end
end
