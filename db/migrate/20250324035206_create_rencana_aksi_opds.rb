class CreateRencanaAksiOpds < ActiveRecord::Migration[6.1]
  def change
    create_table :rencana_aksi_opds do |t|
      t.string :tw1
      t.string :tw2
      t.string :tw3
      t.string :tw4
      t.boolean :is_hidden, default: false
      t.string :tahun
      t.string :kode_opd
      t.string :id_rencana_renaksi, null: false
      t.references :sasaran, null: false, foreign_key: true

      t.timestamps
    end
  end
end
