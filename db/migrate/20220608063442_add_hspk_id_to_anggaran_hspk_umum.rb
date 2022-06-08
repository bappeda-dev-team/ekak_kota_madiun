class AddHspkIdToAnggaranHspkUmum < ActiveRecord::Migration[6.1]
  def change
    add_column :anggaran_hspk_umums, :hspk_id, :bigint
  end
end
