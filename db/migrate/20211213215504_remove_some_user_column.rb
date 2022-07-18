class RemoveSomeUserColumn < ActiveRecord::Migration[6.1]
  def change
    safety_assured { remove_column :users, :password, :string }
  end
end
