class AddProgramKegiatanToSasarans < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    add_reference_concurrently :sasarans, :program_kegiatan, index: true, null: true, foreign: true
  end
end
