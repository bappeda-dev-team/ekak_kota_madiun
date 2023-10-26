class AddDefinisiOperationalToIndikators < ActiveRecord::Migration[6.1]
  def change
    add_column :indikators, :definisi_operational, :jsonb, null: true
  end
end
