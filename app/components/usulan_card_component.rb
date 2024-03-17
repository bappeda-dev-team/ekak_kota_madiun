# frozen_string_literal: true

class UsulanCardComponent < ViewComponent::Base
  def initialize(sasaran:, jenis:)
    @sasaran = sasaran
    @jenis = jenis
    @usulan_type = @jenis.capitalize
  end

  def jenis_asli
    case @jenis
    when 'musrenbang'
      { title: 'Musrenbang', deskripsi: 'Alamat', uraian: 'Permasalahan' }
    when 'pokpir'
      { title: 'Pokok Pikiran DPRD', deskripsi: 'Alamat', uraian: 'Permasalahan' }
    when 'mandatori'
      { title: 'Mandatori', deskripsi: 'Peraturan Terkait', uraian: 'Uraian' }
    when 'inovasi'
      { title: 'Inisiatif', deskripsi: 'Manfaat', uraian: 'Uraian' }
    else
      { title: '', deskripsi: '', uraian: '' }
    end
  end

  def title
    judul = jenis_asli[:title]
    "Usulan #{judul}"
  end

  def header_deskripsi
    jenis_asli[:deskripsi]
  end

  def header_uraian
    jenis_asli[:uraian]
  end

  def usulans
    @sasaran.usulans.where(usulanable_type: @usulan_type).map(&:usulanable)
  end
end
