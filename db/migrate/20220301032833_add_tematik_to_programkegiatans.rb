class AddTematikToProgramkegiatans < ActiveRecord::Migration[6.1]
  def change
    add_reference :program_kegiatans, :subkegiatan_tematik, null: true, foreign_key: true, index: true
  end
end
