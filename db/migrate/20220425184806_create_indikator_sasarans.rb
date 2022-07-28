class CreateIndikatorSasarans < ActiveRecord::Migration[6.1]
  def change
    create_table :indikator_sasarans do |t|
      t.string :indikator_kinerja, null: true
      t.integer :target, null: true
      t.string :satuan, null: true
      t.string :aspek, null: true
      t.string :id_indikator, unique: true
      t.string :sasaran_id, null: true
      t.timestamps
    end
  end
end
