class AddNipSebelumToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :nip_sebelum, :string, null: true
  end
end
