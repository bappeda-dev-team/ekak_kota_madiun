class UpdateOpdReferenceInUsers < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    safety_assured { remove_column :users, :opd_id, :integer }
    add_index :opds, :kode_opd, unique: true, algorithm: :concurrently
    add_column :users, :kode_opd, :string
    add_foreign_key :users, :opds, column: :kode_opd, primary_key: :kode_opd, validate: false
    validate_foreign_key :users, :opds
  end
end
