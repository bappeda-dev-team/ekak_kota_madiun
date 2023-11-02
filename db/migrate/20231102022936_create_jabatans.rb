class CreateJabatans < ActiveRecord::Migration[6.1]
  def change
    create_table :jabatans do |t|
      t.string :nama_jabatan
      t.string :kelas_jabatan
      t.integer :nilai_jabatan
      t.string :index
      t.string :kode_opd
      t.string :tipe
      t.string :kode_jabatan
      t.string :tahun

      t.timestamps
    end
  end
end
