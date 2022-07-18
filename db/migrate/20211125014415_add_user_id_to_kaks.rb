class AddUserIdToKaks < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    add_reference_concurrently :kaks, :user, index: true
  end
end
