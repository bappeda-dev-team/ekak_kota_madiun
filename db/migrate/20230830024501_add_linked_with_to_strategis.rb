class AddLinkedWithToStrategis < ActiveRecord::Migration[6.1]
  def change
    add_column :strategis, :linked_with, :bigint, null: true
  end
end
