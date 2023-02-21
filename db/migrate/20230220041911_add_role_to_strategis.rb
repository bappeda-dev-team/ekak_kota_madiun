class AddRoleToStrategis < ActiveRecord::Migration[6.1]
  def change
    add_column :strategis, :role, :string, null: true
  end
end
