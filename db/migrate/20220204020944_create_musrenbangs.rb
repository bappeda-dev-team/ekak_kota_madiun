class CreateMusrenbangs < ActiveRecord::Migration[6.1]
  def change
    create_table :musrenbangs do |t|
      t.text :usulan
      t.string :tahun
      t.timestamps
    end
  end
end
