class CreateJenisJabatans < ActiveRecord::Migration[6.1]
  def change
    create_table :jenis_jabatans do |t|
      t.string :nama_jenis, null: false, default: 'Jabatan Fungsional'
      t.integer :nilai, null: false, default: 3
      t.string :keterangan
      t.string :tahun

      t.timestamps
    end
  end
end
