class AddNamaPangkatToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :nama_pangkat, :string, null: true
  end
end
