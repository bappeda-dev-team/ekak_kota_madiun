class UpdateOpdReferenceInProgramKegiatan < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    safety_assured { remove_column :program_kegiatans, :opd_id, :integer }
    add_column :program_kegiatans, :kode_opd, :string
    add_foreign_key :program_kegiatans, :opds, column: :kode_opd, primary_key: :kode_opd, validate: false
    validate_foreign_key :program_kegiatans, :opds
  end
end
