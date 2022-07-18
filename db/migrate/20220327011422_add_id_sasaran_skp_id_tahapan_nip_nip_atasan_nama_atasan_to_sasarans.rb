class AddIdSasaranSkpIdTahapanNipNipAtasanNamaAtasanToSasarans < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!
  def change
    remove_index :sasarans, name: :index_sasarans_on_user_id, algorithm: :concurrently
    safety_assured { remove_column :sasarans, :user_id, :integer }
    add_index :users, :nik, unique: true, algorithm: :concurrently
    add_column :sasarans, :nip_asn, :string
    add_foreign_key :sasarans, :users, column: :nip_asn, primary_key: :nik, validate: false
    validate_foreign_key :sasarans, :users
  end
end
