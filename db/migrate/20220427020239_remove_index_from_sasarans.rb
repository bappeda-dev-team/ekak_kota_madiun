class RemoveIndexFromSasarans < ActiveRecord::Migration[6.1]
  def change
    remove_index :sasarans, name: "index_sasarans_on_program_kegiatan_id"
  end
end
