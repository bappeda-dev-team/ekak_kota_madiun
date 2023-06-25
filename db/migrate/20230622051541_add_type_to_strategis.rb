class AddTypeToStrategis < ActiveRecord::Migration[6.1]
  def change
    add_column :strategis, :type, :string, null: true
  end
end
