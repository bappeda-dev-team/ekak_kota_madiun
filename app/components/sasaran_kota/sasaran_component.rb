# frozen_string_literal: true

class SasaranKota::SasaranComponent < ViewComponent::Base
  def initialize(sasaran:, tahun:)
    super
    @sasaran = sasaran
    @tahun = tahun
  end

  def renaksi
    @sasaran.pohonable.to_s
  end

  def opd
    @sasaran.opd.to_s
  end

  def keterangan
    @sasaran.keterangan.present? ? @sasaran.keterangan : '-'
  end

  def indikators
    @sasaran.pohonable.indikators
  end

  def rowspan
    indikators.size + 1
  end

  # sub_pohons dibawah operasional tidak diambil
  def sub_pohons
    @sasaran.sub_pohons.select(&:pohonable)
  end

  def jenis
    case @sasaran.role
    when 'strategi_pohon_kota'
      'sasaran_opd'
    when 'tactical_pohon_kota'
      'sasaran_program'
    when 'operational_pohon_kota'
      'sasaran_kegiatan'
    else
      'sasaran_kota'
    end
  end

  def title_up
    # suffix = @pohon.instance_of?(Pohon) ? '- Kota' : ''
    prefix = case @sasaran.role
             when 'pohon_kota'
               'Tematik Kota'
             when 'sub_pohon_kota'
               'Sub-Tematik Kota'
             when 'sub_sub_pohon_kota'
               'Sub Sub-Tematik Kota'
             when 'strategi_pohon_kota'
               'Strategic'
             else
               @sasaran.role.chomp("_pohon_kota")
             end
    prefix.titleize
  end
end
