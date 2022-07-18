class AddTahapanToAksis < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    add_reference_concurrently :aksis, :tahapan, index: true, foreign: true, null: true 
  end
end
