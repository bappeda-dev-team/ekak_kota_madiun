class CreateIndikators < ActiveRecord::Migration[6.1]
  def change
    create_table :indikators do |t|
      t.string :indikator
      t.string :target
      t.string :satuan
      t.string :tahun
      t.string :kode
      t.string :jenis
      t.string :sub_jenis

      # t.timestamps
    end
  end
end
