class AddProgramKegiatanToSasarans < ActiveRecord::Migration[6.1]
  def change
    add_reference :sasarans, :program_kegiatan, index: true, null: true, foreign: true
  end
end
