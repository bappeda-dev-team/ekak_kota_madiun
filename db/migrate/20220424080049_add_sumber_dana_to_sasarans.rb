class AddSumberDanaToSasarans < ActiveRecord::Migration[6.1]
  def change
    add_column :sasarans, :sumber_dana, :string, null: true
  end
end
