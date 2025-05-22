# == Schema Information
#
# Table name: rencana_aksi_opds
#
#  id                 :bigint           not null, primary key
#  id_rencana_renaksi :string           not null
#  is_hidden          :boolean          default(FALSE)
#  keterangan         :string
#  kode_opd           :string
#  tahun              :string
#  tw1                :string
#  tw2                :string
#  tw3                :string
#  tw4                :string
#  created_at         :datetime         not null
#  updated_at         :datetime         not null
#  sasaran_id         :bigint           not null
#
# Indexes
#
#  index_rencana_aksi_opds_on_sasaran_id  (sasaran_id)
#
# Foreign Keys
#
#  fk_rails_...  (sasaran_id => sasarans.id)
#
class RencanaAksiOpd < ApplicationRecord
  default_scope { order(:id) }
  has_one :rencana_renaksi, class_name: 'Sasaran', primary_key: :id_rencana_renaksi, foreign_key: :id_rencana
  belongs_to :sasaran

  def to_s
    rencana_renaksi.to_s
  end

  def perintah_walikota?
    rencana_renaksi.is_perintah_walikota
  end

  def inovasi?
    rencana_renaksi.punya_inovasi?
  end

  def program_unggulan?
    rencana_renaksi.termasuk_program_unggulan?
  end

  def aksi
    bintang = if inovasi?
                '*'
              else
                ''
              end
    bintang_biru = if program_unggulan?
                     '*'
                   else
                     ''
                   end

    bintang_merah = if perintah_walikota?
                      '*'
                    else
                      ''
                    end

    "#{rencana_renaksi}
<span class='renaksi-opd-bintang-merah'>#{bintang_merah}</span>
<span class='renaksi-opd-bintang-biru'>#{bintang_biru}</span>
<span class='renaksi-opd-bintang'>#{bintang}</span>"
      .html_safe
  end

  def nama_pemilik
    rencana_renaksi.nama_nip_pemilik
  end

  def nama_pemilik_saja
    rencana_renaksi.nama_pemilik
  end

  def nip_pemilik_saja
    rencana_renaksi.nip_pemilik
  end

  def anggaran_renaksi
    rencana_renaksi.total_anggaran
  rescue NoMethodError
    0
  end

  def subkegiatan_renaksi
    rencana_renaksi.program_kegiatan
  end

  def update_tw_pelaksanaan
    target_setahun = rencana_renaksi.total_target_aksi_bulan
    tw1 = target_setahun.values_at(1, 2, 3).compact_blank.sum
    tw2 = target_setahun.values_at(4, 5, 6).compact_blank.sum
    tw3 = target_setahun.values_at(7, 8, 9).compact_blank.sum
    tw4 = target_setahun.values_at(10, 11, 12).compact_blank.sum
    renaksi_opd = self
    renaksi_opd.update(
      tw1: tw1,
      tw2: tw2,
      tw3: tw3,
      tw4: tw4
    )
  end
end
