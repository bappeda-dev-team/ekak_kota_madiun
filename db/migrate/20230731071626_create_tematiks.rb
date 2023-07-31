class CreateTematiks < ActiveRecord::Migration[6.1]
  def change
    create_table :tematiks do |t|
      t.string :tema
      t.string :keterangan
      t.bigint :tematik_ref_id
      t.string :type

      t.timestamps
    end
  end
end
