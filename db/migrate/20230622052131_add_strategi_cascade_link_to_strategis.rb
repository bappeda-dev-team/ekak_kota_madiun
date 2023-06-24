class AddStrategiCascadeLinkToStrategis < ActiveRecord::Migration[6.1]
  def change
    add_column :strategis, :strategi_cascade_link, :bigint, null: true
  end
end
