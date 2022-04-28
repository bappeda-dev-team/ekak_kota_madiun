class CreateKamusUsulans < ActiveRecord::Migration[6.1]
  def change
    create_table :kamus_usulans do |t|
      t.bigint :id_kamus, unique: true, null: false
      t.bigint :id_unit, null: true
      t.bigint :id_program, null: true
      t.string :bidang_urusan
      t.string :usulan
      t.timestamps
    end
  end
end
