class AddIdUnitKodeUrusanNamaUrusanDllToProgramKegiatans < ActiveRecord::Migration[6.1]
  def change
          # id_unit: sub['id_unit'],
          # kode_urusan: sub['kode_urusan'],
          # nama_urusan: sub['nama_urusan'],
          # kode_bidang_urusan: sub['kode_bidang_urusan'],
          # nama_bidang_urusan: sub['nama_bidang_urusan'],
          # id_program: sub['id_program'],
          # kode_program: sub['kode_program'],
          # id_giat: sub['id_giat'],
          # kode_giat: sub['kode_giat'],
          # id_sub_giat: sub['id_sub_giat'],
          # kode_sub_giat: sub['kode_sub_giat'],
          # pagu: sub['pagu']
    add_column :program_kegiatans, :id_unit, :string
    add_column :program_kegiatans, :kode_urusan, :string
    add_column :program_kegiatans, :nama_urusan, :string
    add_column :program_kegiatans, :kode_bidang_urusan, :string
    add_column :program_kegiatans, :nama_bidang_urusan, :string
    add_column :program_kegiatans, :id_program_sipd, :string
    add_column :program_kegiatans, :kode_program, :string
    add_column :program_kegiatans, :kode_giat, :string
    add_column :program_kegiatans, :id_sub_giat, :string
    add_column :program_kegiatans, :kode_sub_giat, :string
    add_column :program_kegiatans, :pagu, :string # convert to i later
  end
end
