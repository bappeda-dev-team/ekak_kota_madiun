class CreateStrategiKeluarans < ActiveRecord::Migration[6.1]
  def change
    create_table :strategi_keluarans do |t|
      t.text :metode
      t.text :tahapan

      t.timestamps
    end
  end
end
