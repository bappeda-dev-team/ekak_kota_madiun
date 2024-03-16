class AddOpdIdToAnggaranBluds < ActiveRecord::Migration[6.1]
  def change
    add_column :anggaran_bluds, :opd_id, :bigint, null: true
  end
end
