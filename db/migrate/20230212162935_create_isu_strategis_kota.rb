class CreateIsuStrategisKota < ActiveRecord::Migration[6.1]
  def change
    create_table :isu_strategis_kota do |t|
      t.string :kode, null: false
      t.string :isu_strategis, null: false
      t.string :tahun, null: false

      t.timestamps
    end
  end
end
