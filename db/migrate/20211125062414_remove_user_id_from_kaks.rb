class RemoveUserIdFromKaks < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    remove_index :kaks, name: :index_kaks_on_user_id, algorithm: :concurrently
  end
end
