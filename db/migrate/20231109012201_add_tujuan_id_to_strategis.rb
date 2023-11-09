class AddTujuanIdToStrategis < ActiveRecord::Migration[6.1]
  def change
    add_column :strategis, :tujuan_id, :bigint, null: true
  end
end
