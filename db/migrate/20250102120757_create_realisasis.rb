class CreateRealisasis < ActiveRecord::Migration[6.1]
  def change
    create_table :realisasis do |t|
      t.string :tahun
      t.string :realisasi
      t.string :satuan
      t.string :jenis
      t.references :target, null: false, foreign_key: true

      t.timestamps
    end
  end
end
