class CreateDasarHukums < ActiveRecord::Migration[6.1]
  def change
    create_table :dasar_hukums do |t|
      t.text :peraturan
      t.string :judul
      t.string :tahun

      t.timestamps
    end
  end
end
