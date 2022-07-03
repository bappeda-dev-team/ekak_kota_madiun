class AddTematikToProgramkegiatans < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    add_reference_concurrently :program_kegiatans, :subkegiatan_tematik, null: true, foreign_key: true, index: true
  end
end
