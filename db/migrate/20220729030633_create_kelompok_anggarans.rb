class CreateKelompokAnggarans < ActiveRecord::Migration[6.1]
  def change
    create_table :kelompok_anggarans do |t|
      t.string :kode_kelompok
      t.string :tahun
      t.string :kelompok

      t.timestamps
    end
  end
end
