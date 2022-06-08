class BackfillChangePerhitunganType < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def up
    backfill_column_for_type_change :perhitungans, :harga
    backfill_column_for_type_change :perhitungans, :total
    backfill_column_for_type_change :perhitungans, :volume
    backfill_column_for_type_change :koefisiens, :volume
    backfill_column_for_type_change :anggarans, :jumlah

  end

  def down
    # no-op
  end
end
