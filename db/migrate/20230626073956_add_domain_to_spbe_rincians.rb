class AddDomainToSpbeRincians < ActiveRecord::Migration[6.1]
  def change
    add_column :spbe_rincians, :domain_spbe, :string, null: true
  end
end
