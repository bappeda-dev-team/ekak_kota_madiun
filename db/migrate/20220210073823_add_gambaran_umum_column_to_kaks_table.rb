class AddGambaranUmumColumnToKaksTable < ActiveRecord::Migration[6.1]
  def change
    add_column :kaks, :gambaran_umum, :text
  end
end
