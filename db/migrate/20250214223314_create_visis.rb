class CreateVisis < ActiveRecord::Migration[6.1]
  def change
    create_table :visis do |t|
      t.string :visi
      t.integer :urutan, default: 1
      t.string :keterangan
      t.string :tahun_awal
      t.string :tahun_akhir

      t.timestamps
    end
  end
end
