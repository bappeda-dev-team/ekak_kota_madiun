class CreateSubkegiatanTematiks < ActiveRecord::Migration[6.1]
  def change
    create_table :subkegiatan_tematiks do |t|
      t.string :nama_tematik
      t.string :kode_tematik, null: true
      t.string :tahun, null: true
      t.timestamps
    end
  end
end
