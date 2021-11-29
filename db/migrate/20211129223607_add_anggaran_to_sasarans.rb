class AddAnggaranToSasarans < ActiveRecord::Migration[6.1]
  def change
    add_column :sasarans, :anggaran, :integer, null: true
  end
end
