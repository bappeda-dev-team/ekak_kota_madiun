# frozen_string_literal: true

class UsulanCardComponent < ViewComponent::Base
  def initialize(sasaran:, jenis:)
    super
    @sasaran = sasaran
    @jenis = jenis
    @usulan_type = @jenis.capitalize
  end

  def jenis_asli
    case @jenis
    when 'musrenbang'
      { usulan: 'Usulan',
        title: 'Musrenbang', deskripsi: 'Alamat', uraian: 'Permasalahan' }
    when 'pokpir'
      { usulan: 'Usulan',
        title: 'Pokok Pikiran DPRD', deskripsi: 'Alamat', uraian: 'Permasalahan' }
    when 'mandatori'
      { usulan: 'Usulan',
        title: 'Mandatori', deskripsi: 'Peraturan Terkait', uraian: 'Uraian' }
    when 'inovasi'
      { usulan: 'Program Unggulan Walikota',
        title: 'Inisiatif', deskripsi: 'ASTA KARYA', uraian: 'Uraian' }
    else
      { usulan: '',
        title: '', deskripsi: '', uraian: '' }
    end
  end

  def title
    jenis_asli[:title]
  end

  def header_usulan
    jenis_asli[:usulan]
  end

  def header_deskripsi
    jenis_asli[:deskripsi]
  end

  def header_uraian
    jenis_asli[:uraian]
  end

  def usulans
    @sasaran.usulans.where(usulanable_type: @usulan_type)
  end

  def id_target_usulan
    dom_id(@sasaran, @jenis)
  end

  def new_name
    if title == 'Inisiatif'
      'Program Unggulan'
    else
      title
    end
  end

  def data_form_ajax
    {
      controller: 'form-ajax',
      form_ajax_target_param: id_target_usulan,
      form_ajax_type_param: 'prepend',
      form_ajax_with_modal_value: 'false',
      action: 'ajax:complete->form-ajax#processAjax'
    }
  end
end
