class AddIdSasaranSkpIdTahapanNipNipAtasanNamaAtasanToSasarans < ActiveRecord::Migration[6.1]
  def change
    remove_column :sasarans, :user_id, :integer
    add_index :users, :nik, unique: true
    add_column :sasarans, :nip_asn, :string
    add_foreign_key :sasarans, :users, column: :nip_asn, primary_key: :nik
  end
end
