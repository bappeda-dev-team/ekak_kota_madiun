class CreateDetailPegawais < ActiveRecord::Migration[6.1]
  def change
    create_table :detail_pegawais do |t|
      t.string :nama
      t.string :nip, null: false, unique: true
      t.string :nik_enc, null: true

      t.timestamps
    end
  end
end
