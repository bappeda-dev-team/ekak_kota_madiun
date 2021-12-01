class CreateAnggarans < ActiveRecord::Migration[6.1]
  def change
    create_table :anggarans do |t|
      t.string :kode_rek
      t.text :uraian
      t.integer :jumlah

      t.timestamps
    end
  end
end
