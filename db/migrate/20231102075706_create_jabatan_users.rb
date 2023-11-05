class CreateJabatanUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :jabatan_users do |t|
      t.bigint :id_jabatan, null: false, foreign_key: true
      t.string :kode_opd, null: false, foreign_key: true
      t.string :nip_asn, null: false, foreign_key: true
      t.string :bulan, null: false
      t.string :tahun, null: false

      t.timestamps
    end
  end
end
