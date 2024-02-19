class CreateAsets < ActiveRecord::Migration[6.1]
  def change
    create_table :asets do |t|
      t.string :nama_aset
      t.integer :jumlah
      t.string :satuan
      t.text :kondisi, array: true, default: []
      t.integer :tahun_awal
      t.integer :tahun_akhir
      t.string :keterangan

      t.timestamps
    end
  end
end
