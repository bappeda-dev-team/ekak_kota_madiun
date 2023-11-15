class RemoveNotNullKodeIsuStrategisOpds < ActiveRecord::Migration[6.1]
  def change
    change_column_null :isu_strategis_opds, :kode, true
  end
end
