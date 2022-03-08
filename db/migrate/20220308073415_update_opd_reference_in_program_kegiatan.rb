class UpdateOpdReferenceInProgramKegiatan < ActiveRecord::Migration[6.1]
  def change
    remove_column :program_kegiatans, :opd_id, :integer
    add_column :program_kegiatans, :kode_opd, :string
    add_foreign_key :program_kegiatans, :opds, column: :kode_opd, primary_key: :kode_opd
  end
end
