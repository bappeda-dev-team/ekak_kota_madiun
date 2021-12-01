class AddLevelToAnggarans < ActiveRecord::Migration[6.1]
  def change
    add_column :anggarans, :level, :integer, :default => 0
  end
end
