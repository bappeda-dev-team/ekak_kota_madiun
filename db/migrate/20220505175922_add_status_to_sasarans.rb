class AddStatusToSasarans < ActiveRecord::Migration[6.1]
  def up
    safety_assured do
      execute <<-SQL
      CREATE TYPE sasaran_status AS ENUM ('draft', 'pengajuan', 'disetujui', 'ditolak');
      SQL
    end
    add_column :sasarans, :status, :sasaran_status, default: 'draft'
  end

  def down
    remove_column :sasarans, :status, :sasaran_status
    safety_assured do
      execute <<-SQL
        DROP TYPE sasaran_status;
      SQL
    end
  end
end
