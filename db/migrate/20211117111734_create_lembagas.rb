class CreateLembagas < ActiveRecord::Migration[6.1]
  def change
    create_table :lembagas do |t|
      t.string :nama_lembaga
      t.time :tahun

      t.timestamps
    end
  end
end
