class ChangeKakDasarHukumAndTujuanColumn < ActiveRecord::Migration[6.1]
  def change
    change_column :kaks, :dasar_hukum, :text, array: true, default: [], using: "(string_to_array(dasar_hukum, ','))"
    change_column :kaks, :tujuan, :text, array: true, default: [], using: "(string_to_array(tujuan, ','))"
  end
end
