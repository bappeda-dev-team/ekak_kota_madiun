class AddUserIdToSasarans < ActiveRecord::Migration[6.1]
  def change
    add_reference :sasarans, :user, index: true
  end
end
