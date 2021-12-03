class AddPajakToAnggarans < ActiveRecord::Migration[6.1]
  def change
    add_reference :anggarans, :pajak, foreign_key: true , null: true
  end
end
