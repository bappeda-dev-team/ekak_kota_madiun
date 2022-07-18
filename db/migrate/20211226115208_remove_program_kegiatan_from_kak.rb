class RemoveProgramKegiatanFromKak < ActiveRecord::Migration[6.1]
  def change
    safety_assured { remove_column :kaks, :program_kegiatan_id, :int }
  end
end
