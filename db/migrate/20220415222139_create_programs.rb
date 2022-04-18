class CreatePrograms < ActiveRecord::Migration[6.1]
  def change
    create_table :programs do |t|
      t.string :id_program
      t.string :tahun
      t.string :kode_program
      t.string :nama_program
      t.string :id_unik
      t.string :indikator
      t.string :satuan
      t.string :target
      t.string :nama_urusan
      t.string :nama_bidang_urusan
      t.timestamps
    end
  end
end
