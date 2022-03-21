class AddUrusanBidangUrusanToOpdsTable < ActiveRecord::Migration[6.1]
  def change
    add_column :opds, :urusan, :string, null: true
    add_column :opds, :bidang_urusan, :string, null: true
    add_column :program_kegiatans, :indikator_program, :string, null: true
    add_column :program_kegiatans, :target_program, :string, null: true
    add_column :program_kegiatans, :satuan_target_program, :string, null: true
  end
end
