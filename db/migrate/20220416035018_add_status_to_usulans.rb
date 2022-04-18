class AddStatusToUsulans < ActiveRecord::Migration[6.1]
  def up
    safety_assured do
      execute <<-SQL
      CREATE TYPE usulan_status AS ENUM ('draft', 'pengajuan', 'disetujui', 'ditolak');
      SQL
    end
    add_column :musrenbangs, :status, :usulan_status, default: 'draft'
    add_column :pokpirs, :status, :usulan_status, default: 'draft'
    add_column :mandatoris, :status, :usulan_status, default: 'draft'
    add_column :inovasis, :status, :usulan_status, default: 'draft'
  end

  def down
    remove_column :musrenbangs, :status, :usulan_status
    remove_column :pokpirs, :status, :usulan_status
    remove_column :mandatoris, :status, :usulan_status
    remove_column :inovasis, :status, :usulan_status
    safety_assured do
      execute <<-SQL
        DROP TYPE usulan_status;
      SQL
    end
  end
end
