class CreateSpbeRincians < ActiveRecord::Migration[6.1]
  def change
    create_table :spbe_rincians do |t|
      t.string :kebutuhan_spbe
      t.string :detail_kebutuhan
      t.string :detail_sasaran_kinerja
      t.string :keterangan

      t.string :kode_opd
      t.string :kode_program
      t.string :id_rencana
      t.string :strategi_ref_id

      t.references :spbe, index: false
      t.timestamps
    end
  end
end
