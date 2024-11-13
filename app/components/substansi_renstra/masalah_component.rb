# frozen_string_literal: true

class SubstansiRenstra::MasalahComponent < ViewComponent::Base
  def initialize(strategi:, no_row:)
    super
    @strategi = strategi
    @no_row = no_row
  end

  def masalah
    @strategi.to_s
  end

  def jenis_masalah
    case @strategi.role
    when 'eselon_2'
      'Masalah Pokok'
    when 'eselon_3'
      'Masalah'
    else
      'Akar Masalah'
    end
  end

  def style_masalah
    case @strategi.role
    when 'eselon_2'
      'sasaran_opd'
    when 'eselon_3'
      'sasaran_program'
    else
      'sasaran_kegiatan'
    end
  end

  def edit_button
    render EditRowButtonComponent.new(path: '#',
                                      title: 'Input Masalah',
                                      btn_style: 'btn btn-primary')
  end
end
