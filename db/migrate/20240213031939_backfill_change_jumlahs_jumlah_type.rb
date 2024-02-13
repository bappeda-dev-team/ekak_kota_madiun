class BackfillChangeJumlahsJumlahType < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def up
    backfill_column_for_type_change :jumlahs, :jumlah
  end

  def down
    # no op
  end
end
