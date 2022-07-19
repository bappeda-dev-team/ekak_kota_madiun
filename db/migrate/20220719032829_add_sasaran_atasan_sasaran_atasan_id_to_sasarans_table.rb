class AddSasaranAtasanSasaranAtasanIdToSasaransTable < ActiveRecord::Migration[6.1]
  def change
    add_column :sasarans, :sasaran_atasan_id, :string, null: true
    add_column :sasarans, :sasaran_atasan, :string, null: true
  end
end
