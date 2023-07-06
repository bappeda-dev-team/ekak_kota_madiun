class AddSubdomainToRincianSpbe < ActiveRecord::Migration[6.1]
  def change
    add_column :spbe_rincians, :subdomain_spbe, :string, null: true
  end
end
