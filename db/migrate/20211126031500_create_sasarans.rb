class CreateSasarans < ActiveRecord::Migration[6.1]
  def change
    create_table :sasarans do |t|
      t.string :sasaran_kinerja
      t.string :indikator_kinerja
      t.integer :target
      t.integer :kualitas
      t.string :satuan
      t.string :penerima_manfaat
      

      t.timestamps
    end
  end
end
