# frozen_string_literal: true

class SubstansiRenstra::DasarHukumComponent < ViewComponent::Base
  def initialize(dasar_hukum:, jenis:)
    super
    @dasar_hukum = dasar_hukum
    @jenis = jenis
  end

  def id_dasar_hukum
    dom_id(@dasar_hukum)
  end

  def judul
    if @jenis == 'DasarHukum'
      @dasar_hukum.judul
    else
      @dasar_hukum.peraturan_terkait
    end
  end

  def peraturan
    if @jenis == 'DasarHukum'
      @dasar_hukum.peraturan
    else
      @dasar_hukum.uraian
    end
  end

  def edit_path
    if @jenis == 'DasarHukum'
      edit_renstra_dasar_hukum_path(@dasar_hukum)
    else
      edit_renstra_mandatori_path(@dasar_hukum)
    end
  end

  def delete_path
    if @jenis == 'DasarHukum'
      hapus_renstra_dasar_hukum_path(@dasar_hukum)
    else
      @dasar_hukum
    end
  end

  def edit_button
    render EditRowButtonComponent.new(path: edit_path)
  end

  def delete_button
    render DeleteButtonAjaxComponent.new(path: delete_path,
                                         model: @dasar_hukum,
                                         text: 'Hapus dasar hukum ?')
  end
end
