class AddInternalExternalToSpbeRincian < ActiveRecord::Migration[6.1]
  def change
    add_column :spbe_rincians, :internal_external, :string
    add_column :spbe_rincians, :tahun_pelaksanaan, :string
    add_column :spbe_rincians, :tahun_awal, :string
    add_column :spbe_rincians, :tahun_akhir, :string
  end
end
