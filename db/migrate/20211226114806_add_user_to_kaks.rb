class AddUserToKaks < ActiveRecord::Migration[6.1]
  def change
    add_reference :kaks, :user, index: true, null: false
  end
end
