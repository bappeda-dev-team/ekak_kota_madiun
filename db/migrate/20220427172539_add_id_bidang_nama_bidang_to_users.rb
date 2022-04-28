class AddIdBidangNamaBidangToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :id_bidang, :bigint, null: true
    add_column :users, :nama_bidang, :string, null: true
  end
end
