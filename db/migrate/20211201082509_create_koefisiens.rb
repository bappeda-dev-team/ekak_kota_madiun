class CreateKoefisiens < ActiveRecord::Migration[6.1]
  def change
    create_table :koefisiens do |t|
      t.integer :volume
      t.string :satuan_volume

      t.timestamps
    end
  end
end
