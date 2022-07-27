class AddKodeLembagaToLembagasTable < ActiveRecord::Migration[6.1]
  def change
    add_column :lembagas, :kode_lembaga, :string, null: true
  end
end
