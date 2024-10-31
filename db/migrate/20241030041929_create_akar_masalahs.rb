class CreateAkarMasalahs < ActiveRecord::Migration[6.1]
  def change
    create_table :akar_masalahs do |t|
      t.string :masalah
      t.string :kode_opd
      t.string :tahun
      t.bigint :parent_id
      t.string :jenis

      t.timestamps
    end
  end
end
