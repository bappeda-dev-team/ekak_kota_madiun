class AddTahapanToAnggarans < ActiveRecord::Migration[6.1]
  def change
    add_reference :anggarans, :tahapan, foreign: true, index: true, null: true
  end
end
