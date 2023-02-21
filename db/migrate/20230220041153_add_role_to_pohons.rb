class AddRoleToPohons < ActiveRecord::Migration[6.1]
  def change
    add_column :pohons, :role, :string, null: true
  end
end
