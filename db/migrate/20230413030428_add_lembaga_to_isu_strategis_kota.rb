class AddLembagaToIsuStrategisKota < ActiveRecord::Migration[6.1]
  def change 
    add_column :isu_strategis_kota, :lembaga_id, :bigint, default: 1
  end
end
