class CreatePermasalahanOpds < ActiveRecord::Migration[6.1]
  def change
    create_table :permasalahan_opds do |t|
      t.string :permasalahan
      t.string :kode_opd
      t.string :tahun
      t.string :jenis
      t.string :kode_permasalahan_external, null: true
      t.string :status
      t.references :isu_strategis_opd

      t.timestamps
    end
  end
end
