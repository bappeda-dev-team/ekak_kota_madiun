class CreateAksis < ActiveRecord::Migration[6.1]
  def change
    create_table :aksis do |t|
      t.integer :target
      t.integer :realisasi
      t.integer :bulan

      t.timestamps
    end
  end
end
