class CreateRincians < ActiveRecord::Migration[6.1]
  def change
    create_table :rincians do |t|
      t.references :sasaran, null: false, foreign_key: true
      t.string :data_terpilah
      t.string :penyebab_internal
      t.string :penyebab_external
      t.string :permasalahan_umum
      t.string :permasalahan_gender
      t.string :resiko
      t.string :lokasi_pelaksanaan
      t.timestamps
    end
  end
end
