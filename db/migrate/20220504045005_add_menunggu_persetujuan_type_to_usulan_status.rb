class AddMenungguPersetujuanTypeToUsulanStatus < ActiveRecord::Migration[6.1]
  def up
    safety_assured do
      execute <<-SQL
      ALTER TYPE usulan_status ADD VALUE 'menunggu_persetujuan';
      ALTER TYPE usulan_status ADD VALUE 'aktif';
      SQL
    end
  end

  def down
    safety_assured do
      execute <<-SQL
      UPDATE musrenbangs SET status = 'disetujui' WHERE status = 'menunggu_persetujuan';
      UPDATE pokpirs SET status = 'disetujui' WHERE status = 'menunggu_persetujuan';
      UPDATE inovasis SET status = 'disetujui' WHERE status = 'menunggu_persetujuan';
      UPDATE mandatoris SET status = 'disetujui' WHERE status = 'menunggu_persetujuan';

      UPDATE musrenbangs SET status = 'disetujui' WHERE status = 'aktif';
      UPDATE pokpirs SET status = 'disetujui' WHERE status = 'aktif';
      UPDATE inovasis SET status = 'disetujui' WHERE status = 'aktif';
      UPDATE mandatoris SET status = 'disetujui' WHERE status = 'aktif';
      
      ALTER TYPE usulan_status RENAME TO usulan_status_old;
      CREATE TYPE usulan_status AS ENUM ('draft', 'pengajuan', 'disetujui', 'ditolak');
      
      ALTER TABLE musrenbangs ALTER COLUMN status DROP DEFAULT;
      ALTER TABLE pokpirs ALTER COLUMN status DROP DEFAULT;
      ALTER TABLE inovasis ALTER COLUMN status DROP DEFAULT;
      ALTER TABLE mandatoris ALTER COLUMN status DROP DEFAULT;

      ALTER TABLE musrenbangs ALTER COLUMN status TYPE usulan_status USING status::text::usulan_status;
      ALTER TABLE pokpirs ALTER COLUMN status TYPE usulan_status USING status::text::usulan_status;
      ALTER TABLE inovasis ALTER COLUMN status TYPE usulan_status USING status::text::usulan_status;
      ALTER TABLE mandatoris ALTER COLUMN status TYPE usulan_status USING status::text::usulan_status;

      ALTER TABLE musrenbangs ALTER COLUMN status SET DEFAULT 'draft';
      ALTER TABLE pokpirs ALTER COLUMN status SET DEFAULT 'draft';
      ALTER TABLE inovasis ALTER COLUMN status SET DEFAULT 'draft';
      ALTER TABLE mandatoris ALTER COLUMN status SET DEFAULT 'draft';
      DROP TYPE usulan_status_old;
      SQL
    end
  end
end
