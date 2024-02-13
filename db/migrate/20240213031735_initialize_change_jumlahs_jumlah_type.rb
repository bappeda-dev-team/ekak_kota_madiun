class InitializeChangeJumlahsJumlahType < ActiveRecord::Migration[6.1]
  def change
    initialize_column_type_change :jumlahs, :jumlah, :decimal
  end
end
