class AddOpdIdToAnggaranSshes < ActiveRecord::Migration[6.1]
  def change
    add_column :anggaran_sshes, :opd_id, :bigint, null: true
  end
end
