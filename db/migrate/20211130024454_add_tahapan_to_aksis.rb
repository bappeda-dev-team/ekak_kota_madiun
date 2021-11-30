class AddTahapanToAksis < ActiveRecord::Migration[6.1]
  def change
    add_reference :aksis, :tahapan, index: true, foreign: true, null: true 
  end
end
