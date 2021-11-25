class RemoveUserIdFromKaks < ActiveRecord::Migration[6.1]
  def change
    remove_reference :kaks, :user, index: true
  end
end
