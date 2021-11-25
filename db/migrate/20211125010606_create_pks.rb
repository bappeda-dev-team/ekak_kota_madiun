class CreatePks < ActiveRecord::Migration[6.1]
  def change
    create_table :pks do |t|
      t.string :sasaran
      t.string :indikator_kinerja
      t.string :target
      t.string :satuan
      t.references :user, null: false, foreign_key: true

      t.timestamps
    end
  end
end
