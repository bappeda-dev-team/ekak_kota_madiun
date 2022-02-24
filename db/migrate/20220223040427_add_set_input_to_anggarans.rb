class AddSetInputToAnggarans < ActiveRecord::Migration[6.1]
  def change
    add_column :anggarans, :set_input, :string, default: 0
  end
end
