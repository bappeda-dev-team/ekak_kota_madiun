class AddEselonPangkatJabatanEselonToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :pangkat, :string, null: true
    add_column :users, :jabatan, :string, null: true
    add_column :users, :eselon, :string, null: true
  end
end
