class AddKodeSubSkpdToProgramKegiatans < ActiveRecord::Migration[6.1]
  def change
    add_column :program_kegiatans, :kode_skpd, :string, null: true
    add_column :program_kegiatans, :kode_sub_skpd, :string, null: true
    add_column :program_kegiatans, :id_sub_unit, :string, null: true
    add_column :program_kegiatans, :id_giat, :string, null: true
  end
end
