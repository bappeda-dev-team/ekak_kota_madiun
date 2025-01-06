class AddIsHiddenToIndikatorSasarans < ActiveRecord::Migration[6.1]
  def change
    add_column :indikator_sasarans, :is_hidden, :boolean, null: false, default: false
  end
end
