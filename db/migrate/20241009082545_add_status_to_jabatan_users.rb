class AddStatusToJabatanUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :jabatan_users, :status, :string, null: true, default: 'aktif'
  end
end
