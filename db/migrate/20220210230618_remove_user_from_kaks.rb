class RemoveUserFromKaks < ActiveRecord::Migration[6.1]
  def change
    remove_reference :kaks, :user, index: true, null: false
  end
end
