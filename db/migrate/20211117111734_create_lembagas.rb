class CreateLembagas < ActiveRecord::Migration[6.1]
  def change
    create_table :lembagas do |t|
      t.string :nama_lembaga
      t.string :tahun

      t.timestamps
    end
  end
end
