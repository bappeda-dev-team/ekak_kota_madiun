# == Schema Information
#
# Table name: inovasi_masyarakats
#
#  id                      :bigint           not null, primary key
#  alamat                  :string
#  email_pelapor           :string
#  gambaran_nilai_kebaruan :string
#  id_tiket                :string
#  inovasi                 :string
#  keterangan              :string
#  metadata                :jsonb
#  nama_pelapor            :string
#  no_whatsapp             :string
#  status_laporan          :string
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#
# Indexes
#
#  index_inovasi_masyarakats_on_id_tiket  (id_tiket) UNIQUE
#
FactoryBot.define do
  factory :inovasi_masyarakat do
    nama_pelapor { "MyString" }
    no_whatsapp { "MyString" }
    alamat { "MyString" }
    email_pelapor { "MyString" }
    inovasi { "MyString" }
    gambaran_nilai_kebaruan { "MyString" }
    status_laporan { "MyString" }
    keterangan { "MyString" }
    metadata { "" }
    id_tiket { "MyString" }
  end
end
