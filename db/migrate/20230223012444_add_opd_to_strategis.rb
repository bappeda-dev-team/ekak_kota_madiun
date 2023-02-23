class AddOpdToStrategis < ActiveRecord::Migration[6.1]
  def change
    add_column :strategis, :opd_id, :string, null: true
  end
end
