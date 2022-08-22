class CreateSkalas < ActiveRecord::Migration[6.1]
  def change
    create_table :skalas do |t|
      t.string :kode_skala
      t.string :jenis
      t.string :pilihan
      t.string :jenis_skor
      t.string :skor

      t.timestamps
    end
  end
end
