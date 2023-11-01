class CreateStatusTombols < ActiveRecord::Migration[6.1]
  def change
    create_table :status_tombols do |t|
      t.boolean :disabled
      t.string :tombol
      t.string :keterangan
      t.string :kode_tombol
      t.string :kode_opd
      t.string :tahun

      t.timestamps
    end
  end
end
