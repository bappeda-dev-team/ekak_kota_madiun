class AddUniqueIndexNipToDetailPegawais < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    add_index :detail_pegawais, :nip, unique: true, algorithm: :concurrently
  end
end
