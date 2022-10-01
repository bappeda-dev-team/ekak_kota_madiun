class AddSasaranMilikToSasarans < ActiveRecord::Migration[6.1]
  def change
    add_column :sasarans, :sasaran_milik, :string, null: true
  end
end
