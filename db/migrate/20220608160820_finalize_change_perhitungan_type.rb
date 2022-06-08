class FinalizeChangePerhitunganType < ActiveRecord::Migration[6.1]
  disable_ddl_transaction!

  def change
    finalize_column_type_change :perhitungans, :harga
    finalize_column_type_change :perhitungans, :total
    finalize_column_type_change :perhitungans, :volume
    finalize_column_type_change :koefisiens, :volume
    finalize_column_type_change :anggarans, :jumlah
  end
end
