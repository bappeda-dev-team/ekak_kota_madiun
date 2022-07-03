class AddPajakToAnggarans < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    add_reference_concurrently :anggarans, :pajak, foreign_key: true , null: true
  end
end
