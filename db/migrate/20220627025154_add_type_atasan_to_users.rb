class AddTypeAtasanToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :type, :string, null: true
    add_column :users, :atasan, :string, null: true
  end
end
