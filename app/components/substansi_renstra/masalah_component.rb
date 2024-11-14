# frozen_string_literal: true

class SubstansiRenstra::MasalahComponent < ViewComponent::Base
  with_collection_parameter :strategi
  include AkarMasalahsHelper

  def initialize(strategi:)
    super
    @strategi = strategi
  end

  def rowspan
    if role == 'eselon_2'
      rowspan_masalah_pokok(@strategi.strategi_bawahans)
    elsif role == 'eselon_3'
      rowspan_masalah(@strategi.strategi_bawahans)
    else
      1
    end
  end

  def strategi_bawahans
    @strategi.strategi_bawahans
  end

  def masalah
    @strategi.to_s
  end

  def role
    @strategi.role
  end

  def style_masalah
    case role
    when 'eselon_2'
      'sasaran_opd'
    when 'eselon_3'
      'sasaran_program skip'
    else
      'sasaran_kegiatan skip'
    end
  end

  def jenis_masalah
    case role
    when 'eselon_2'
      'Masalah Pokok'
    when 'eselon_3'
      'Masalah'
    else
      'AkarMasalah'
    end
  end

  def edit_button
    render EditColButtonComponent.new(path: new_akar_masalah_path(strategi_id: @strategi, jenis: jenis_masalah, rowspan: rowspan),
                                      title: 'Input Masalah',
                                      btn_style: 'btn btn-primary')
  end
end
