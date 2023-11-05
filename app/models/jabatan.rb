# == Schema Information
#
# Table name: jabatans
#
#  id            :bigint           not null, primary key
#  id_jabatan    :bigint
#  index         :string
#  kelas_jabatan :string
#  kode_opd      :string
#  nama_jabatan  :string
#  nilai_jabatan :integer
#  tahun         :string
#  tipe          :string
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#
class Jabatan < ApplicationRecord
end
