class CreateSumberDanas < ActiveRecord::Migration[6.1]
  def change
    create_table :sumber_danas do |t|
      t.string :kode_sumber_dana
      t.string :sumber_dana
      t.string :tahun

      t.timestamps
    end
  end
end
