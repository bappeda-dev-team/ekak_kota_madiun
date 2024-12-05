class AddInovasiMasyarakatToInovasiTims < ActiveRecord::Migration[6.1]
  def change
    add_column :inovasi_tims, :inovasi_masyarakat_id, :bigint
  end
end
