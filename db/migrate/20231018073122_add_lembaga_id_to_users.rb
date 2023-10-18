class AddLembagaIdToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :lembaga_id, :int, default: 1
  end
end
