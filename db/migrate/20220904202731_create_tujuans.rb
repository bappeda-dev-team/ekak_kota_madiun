class CreateTujuans < ActiveRecord::Migration[6.1]
  def change
    create_table :tujuans do |t|
      t.string :tujuan
      t.string :id_tujuan, null: false
      t.string :type
      t.string :kode_unik_opd

      t.timestamps
      t.index :id_tujuan, unique: true
    end
  end
end
