class AddUniqueToIdSasaranSasaranOpds < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    add_index :sasaran_opds, :id_sasaran, unique: true, algorithm: :concurrently
  end
end
