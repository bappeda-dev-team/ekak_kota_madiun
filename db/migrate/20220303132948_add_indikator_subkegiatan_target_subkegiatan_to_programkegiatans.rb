class AddIndikatorSubkegiatanTargetSubkegiatanToProgramkegiatans < ActiveRecord::Migration[6.1]
  def change
    add_column :program_kegiatans, :indikator_subkegiatan, :string
    add_column :program_kegiatans, :target_subkegiatan, :string
    add_column :program_kegiatans, :satuan_target_subkegiatan, :string
  end
end
