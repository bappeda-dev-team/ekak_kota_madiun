class AddVisiToTujuanKota < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    add_reference_concurrently :tujuan_kota, :visi, null: true, foreign_key: true
  end
end
