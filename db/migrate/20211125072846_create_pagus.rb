class CreatePagus < ActiveRecord::Migration[6.1]
  def change
    create_table :pagus do |t|
      t.string :item
      t.integer :uang
      t.string :tipe
      t.string :satuan
      t.integer :volume

      t.timestamps
    end
  end
end
