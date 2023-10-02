class CreateKriteria < ActiveRecord::Migration[6.1]
  def change
    create_table :kriteria do |t|
      t.string :kriteria
      t.integer :poin_max
      t.integer :poin_min
      t.string :keterangan
      t.string :type
      t.string :tipe_kriteria
      t.bigint :kriteria_id

      t.timestamps
    end
  end
end
