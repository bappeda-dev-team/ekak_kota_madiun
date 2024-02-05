class AddTematikToSasaranKota < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    add_reference_concurrently :sasaran_kota, :tematik, null: true
  end
end
