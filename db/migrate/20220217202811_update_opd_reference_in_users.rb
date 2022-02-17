class UpdateOpdReferenceInUsers < ActiveRecord::Migration[6.1]
  def change
    remove_column :users, :opd_id, :integer
    add_index :opds, :kode_opd, unique: true
    add_column :users, :kode_opd, :string
    add_foreign_key :users, :opds, column: :kode_opd, primary_key: :kode_opd
  end
end
