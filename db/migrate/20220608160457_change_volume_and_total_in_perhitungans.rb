class ChangeVolumeAndTotalInPerhitungans < ActiveRecord::Migration[6.1]
  def change
    initialize_column_type_change :perhitungans, :harga, :decimal
    initialize_column_type_change :perhitungans, :total, :decimal
    initialize_column_type_change :perhitungans, :volume, :decimal
    initialize_column_type_change :anggarans, :jumlah, :decimal
    initialize_column_type_change :koefisiens, :volume, :decimal
  end
end
