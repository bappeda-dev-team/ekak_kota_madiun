class AddSasaranToTahapans < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    add_reference_concurrently :tahapans, :sasaran, index: true, null: true
  end
end
