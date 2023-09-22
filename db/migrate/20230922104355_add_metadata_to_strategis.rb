class AddMetadataToStrategis < ActiveRecord::Migration[6.1]
  def change
    add_column :strategis, :metadata, :jsonb, null: true
  end
end
