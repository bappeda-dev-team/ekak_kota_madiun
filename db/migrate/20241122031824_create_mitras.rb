class CreateMitras < ActiveRecord::Migration[6.1]
  def change
    create_table :mitras do |t|
      t.string :jenis_mitra
      t.string :nama_kerjasama
      t.string :penjelasan_kerjasama
      t.string :tahun_kerjasama
      t.string :keterangan
      t.references :crosscutting, null: false, foreign_key: true

      t.timestamps
    end
  end
end
