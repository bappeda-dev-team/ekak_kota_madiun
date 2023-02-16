class CreateStrategiOpds < ActiveRecord::Migration[6.1]
  def change
    create_table :strategi_opds do |t|
      t.string :strategi
      t.string :tahun
      t.string :sasaran_opd_id
      t.string :isu_strategis_opd_id
      t.string :opd_id

      t.timestamps
    end
  end
end
