class AddAspekToSpbeRincians < ActiveRecord::Migration[6.1]
  def change
    add_column :spbe_rincians, :aspek_spbe, :string, null: true
  end
end
