class FinalizeChangeJumlahsJumlahType < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    finalize_column_type_change :jumlahs, :jumlah
  end
end
