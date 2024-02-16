class AddJenisJabatanToJabatans < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    add_reference_concurrently :jabatans, :jenis_jabatan
  end
end
