class ChangeKakDasarHukumAndTujuanColumn < ActiveRecord::Migration[6.1]
  def change
    change_column :kaks, :dasar_hukum, :text, using: 'dasar_hukum::text[]',array: true, default: []
    change_column :kaks, :tujuan, :text, using: 'tujuan::text[]',array: true, default: []
  end
end
