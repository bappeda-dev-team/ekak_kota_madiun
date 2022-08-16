class AddTypeToIndikatorSasaransTable < ActiveRecord::Migration[6.1]
  def change
    add_column :indikator_sasarans, :type, :string, null: true
  end
end
