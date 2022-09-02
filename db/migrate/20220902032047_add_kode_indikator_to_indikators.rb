class AddKodeIndikatorToIndikators < ActiveRecord::Migration[6.1]
  def change
    add_column :indikators, :kode_indikator, :string
  end
end
