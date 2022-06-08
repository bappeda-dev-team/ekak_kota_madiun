class CleanupChangePerhitunganType < ActiveRecord::Migration[6.1]
  def up
    cleanup_column_type_change :perhitungans, :harga
    cleanup_column_type_change :perhitungans, :total
    cleanup_column_type_change :perhitungans, :volume
    cleanup_column_type_change :koefisiens, :volume
    cleanup_column_type_change :anggarans, :jumlah

  end

  def down
    initialize_column_type_change :perhitungans, :harga, :integer
    initialize_column_type_change :perhitungans, :total, :integer
    initialize_column_type_change :perhitungans, :volume, :integer
    initialize_column_type_change :anggarans, :jumlah, :integer
    initialize_column_type_change :koefisiens, :volume, :integer
  end
end
