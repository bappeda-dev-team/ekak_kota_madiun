class CreateIsuStrategisOpds < ActiveRecord::Migration[6.1]
  def change
    create_table :isu_strategis_opds do |t|
      t.string :kode, null: false
      t.string :isu_strategis, null: false
      t.string :tahun, null: false
      t.string :kode_opd, null: false
      t.string :tujuan

      t.timestamps
    end
  end
end
