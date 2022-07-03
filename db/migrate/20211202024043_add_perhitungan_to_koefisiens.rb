class AddPerhitunganToKoefisiens < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    add_reference_concurrently :koefisiens, :perhitungan, index: true, null: true
  end
end
