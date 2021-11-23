class AddProgramKegiatanIdToKaks < ActiveRecord::Migration[6.1]
  def change
    add_column :kaks, :program_kegiatan_id, :int
  end
end
