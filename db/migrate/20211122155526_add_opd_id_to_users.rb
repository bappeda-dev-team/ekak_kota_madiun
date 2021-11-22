class AddOpdIdToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :opd_id, :int
  end
end
