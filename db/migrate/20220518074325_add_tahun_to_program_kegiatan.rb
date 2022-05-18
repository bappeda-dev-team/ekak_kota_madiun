class AddTahunToProgramKegiatan < ActiveRecord::Migration[6.1]
  def change
    add_column :program_kegiatans, :tahun, :string, null: true
  end
end
