# frozen_string_literal: true

class SubstansiRenstra::MasalahComponent < ViewComponent::Base
  with_collection_parameter :strategi
  include AkarMasalahsHelper
  include Rails.application.routes.url_helpers

  def initialize(strategi:, single: false)
    super
    @strategi = strategi
    @single = single
  end

  def rowspan
    if role == 'eselon_2'
      rowspan_masalah_pokok(@strategi.strategi_bawahans.where(role: 'eselon_3'))
    elsif role == 'eselon_3'
      rowspan_masalah(@strategi.strategi_bawahans.where(role: 'eselon_4'))
    else
      1
    end
  end

  def strategi_bawahans
    if role == 'eselon_2'
      @strategi.strategi_bawahans.where(role: 'eselon_3')
    elsif role == 'eselon_3'
      @strategi.strategi_bawahans.where(role: 'eselon_4')
    else
      @strategi.strategi_bawahans.where(role: 'staff')
    end
  end

  def have_masalah?
    @strategi.akar_masalah.present?
  end

  def masalah
    if have_masalah?
      @strategi.akar_masalah.to_s
    else
      @strategi.to_s
    end
  end

  def role
    @strategi.role
  end

  def style_masalah
    case role
    when 'eselon_2'
      'sasaran_opd akar-masalah'
    when 'eselon_3'
      'sasaran_program skip akar-masalah'
    else
      'sasaran_kegiatan skip akar-masalah'
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

  def btn_style
    if have_masalah?
      { title: "Edit #{jenis_masalah}",
        btn_style: 'btn btn-info',
        path: edit_akar_masalah_path(@strategi.akar_masalah, rowspan: rowspan) }
    else
      { title: "Input #{jenis_masalah}",
        btn_style: 'btn btn-primary',
        path: new_akar_masalah_path(strategi_id: @strategi, jenis: jenis_masalah, rowspan: rowspan) }
    end
  end

  def atas_terpilih?
    if role == 'eselon_2'
      false
    elsif role == 'eselon_4'
      str = @strategi.strategi_atasan.strategi_atasan.masalah_terpilih
      tact = @strategi.strategi_atasan.masalah_terpilih
      str || tact
    else
      @strategi.strategi_atasan.masalah_terpilih
    end
  end

  def bawah_terpilih?
    if role == 'eselon_4'
      false
    elsif role == 'eselon_2'
      strategi_bawahans.any? do |str|
        tact = str.masalah_terpilih
        opr = str.strategi_bawahans.any?(&:masalah_terpilih)
        tact || opr
      end
    else
      strategi_bawahans.any?(&:masalah_terpilih)
    end

    ## untuk cek dari atas semua
    ## if role == eselon_4
    ## false
    ## elsif role == 'eselon_3'
    ## str.strategi_atasan.strategi_bawahans.any? do |str|
    ## str.strategi_bawahans.any?(&:masalah_terpilih)
    ## end
    ## else
    ## str.strategi_bawahans.any? do |str|
    ## str.strategi_bawahans.any?(&:masalah_terpilih)
    ## end
    ## end
  end

  def strategi_segaris_terpilih?
    self_terpilih = @strategi.masalah_terpilih
    self_terpilih || bawah_terpilih? || atas_terpilih?
  end

  def terpilih?
    return false unless have_masalah?

    @strategi.akar_masalah.terpilih
  end

  def edit_button
    render EditColButtonComponent.new(path: btn_style[:path],
                                      title: btn_style[:title],
                                      btn_style: btn_style[:btn_style])
  end

  def pilih_button
    return unless have_masalah? && !terpilih? && !strategi_segaris_terpilih?

    path = pilih_masalah_akar_masalah_path(@strategi.akar_masalah)

    render ButtonAjaxComponent.new(title: 'Pilih Permasalahan',
                                   path: path)
  end
end
