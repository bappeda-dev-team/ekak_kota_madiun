class CreateSkalas < ActiveRecord::Migration[6.1]
  def change
    create_table :skalas do |t|
      t.string :kode_skala
      t.string :deskripsi, null: true
      t.string :nilai, null: true
      t.string :tipe_nilai, null: true
      t.string :keterangan, null: true
      t.string :type
      t.timestamps
    end
  end
end
