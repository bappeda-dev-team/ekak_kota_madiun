class CreatePajaks < ActiveRecord::Migration[6.1]
  def change
    create_table :pajaks do |t|
      t.string :tahun
      t.string :tipe
      t.float :potongan

      t.timestamps
    end
  end
end
