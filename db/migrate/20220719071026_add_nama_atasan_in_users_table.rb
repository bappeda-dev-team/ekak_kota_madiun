class AddNamaAtasanInUsersTable < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :atasan_nama, :string, null: true
  end
end
