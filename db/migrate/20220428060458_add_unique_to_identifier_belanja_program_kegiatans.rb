class AddUniqueToIdentifierBelanjaProgramKegiatans < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    add_index :program_kegiatans, :identifier_belanja, unique: true, algorithm: :concurrently
  end
end
