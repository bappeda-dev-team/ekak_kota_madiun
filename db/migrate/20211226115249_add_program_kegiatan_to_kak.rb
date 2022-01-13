class AddProgramKegiatanToKak < ActiveRecord::Migration[6.1]
  def change
    add_reference :kaks, :program_kegiatan, null: true, index: true
  end
end
