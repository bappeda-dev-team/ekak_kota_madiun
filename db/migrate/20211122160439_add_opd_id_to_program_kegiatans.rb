class AddOpdIdToProgramKegiatans < ActiveRecord::Migration[6.1]
  def change
    add_column :program_kegiatans, :opd_id, :int
  end
end
