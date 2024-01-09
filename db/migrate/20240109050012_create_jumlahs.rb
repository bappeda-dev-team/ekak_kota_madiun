class CreateJumlahs < ActiveRecord::Migration[6.1]
  def change
    create_table :jumlahs do |t|
      t.integer :jumlah
      t.string :satuan
      t.string :tahun
      t.string :keterangan
      t.references :data_dukung

      t.timestamps
    end
  end
end
