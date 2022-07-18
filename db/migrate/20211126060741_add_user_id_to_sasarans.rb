class AddUserIdToSasarans < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    add_reference_concurrently :sasarans, :user, index: true
  end
end
