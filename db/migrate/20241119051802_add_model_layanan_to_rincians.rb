class AddModelLayananToRincians < ActiveRecord::Migration[6.1]
  def change
    add_column :rincians, :model_layanan, :string
  end
end
