class AddJalurLayananToRincians < ActiveRecord::Migration[6.1]
  def change
    add_column :rincians, :jalur_layanan, :string
  end
end
