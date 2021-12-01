class CreatePerhitungans < ActiveRecord::Migration[6.1]
  def change
    create_table :perhitungans do |t|
      t.string :koefisien
      t.integer :volume
      t.string :satuan
      t.integer :harga

      t.timestamps
    end
  end
end
