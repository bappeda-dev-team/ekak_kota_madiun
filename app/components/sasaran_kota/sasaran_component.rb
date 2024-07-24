# frozen_string_literal: true

class SasaranKota::SasaranComponent < ViewComponent::Base
  def initialize(sasaran:, tahun:)
    super
    @sasaran = sasaran
    @tahun = tahun
  end

  def renaksi
    if jenis == 'sasaran_subkegiatan'
      @sasaran.to_s
    else
      @sasaran.pohonable.to_s
    end
  end

  def opd
    @sasaran.opd.to_s
  end

  def keterangan
    @sasaran.keterangan.present? ? @sasaran.keterangan : '-'
  end

  def indikators
    if jenis == 'sasaran_subkegiatan'
      @sasaran.indikator_sasarans
    else
      @sasaran.pohonable.indikators
    end
  end

  def rowspan
    indikators.size + 1
  end

  # sub_pohons dibawah operasional tidak diambil
  def sub_pohons
    if jenis == 'sasaran_kegiatan'
      @sasaran.pohonable.sasarans.dengan_nip
    else
      @sasaran.sub_pohons.select(&:pohonable)
    end
  end

  def jenis
    case @sasaran.role
    when 'strategi_pohon_kota'
      'sasaran_opd'
    when 'tactical_pohon_kota'
      'sasaran_program'
    when 'operational_pohon_kota'
      'sasaran_kegiatan'
    when 'sub_operational_pohon_kota'
      'sasaran_subkegiatan'
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

  def nama_nip_pelaksanas
    if jenis == 'sasaran_subkegiatan'
      [{ nama: @sasaran.nama_pelaksana,
         nip: @sasaran.nip_asn,
         inovasi: @sasaran.inovasi_sasaran
       }]
    else
      @sasaran.pohonable.sasarans.dengan_nip.flat_map do |sasaran|
        { nama: sasaran.nama_pelaksana,
          nip: sasaran.nip_asn,
          inovasi: sasaran.inovasi_sasaran
        }
      end.uniq
    end
  end
end
