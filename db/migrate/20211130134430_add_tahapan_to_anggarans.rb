class AddTahapanToAnggarans < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    add_reference_concurrently :anggarans, :tahapan, foreign: true, index: true, null: true
  end
end
