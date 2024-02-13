class CleanupChangeJumlahsJumlahType < ActiveRecord::Migration[6.1]
  def up
    cleanup_column_type_change :jumlahs, :jumlah
  end

  def down
    initialize_column_type_change :jumlahs, :jumlah, :integer
  end
end
