module RencanaAksiOpdsHelper
  def rowspan_renaksi_opd(sasaran)
    return 1 if sasaran.nil?

    indikator_row = sasaran.indikator_sasarans.empty? ? 1 : sasaran.indikator_sasarans.length # 4
    renaksi_row = sasaran.rencana_aksi_opds.empty? ? 1 : sasaran.rencana_aksi_opds.length # 3
    rowspan_rumit = indikator_row + renaksi_row - 1

    sasaran.indikator_sasarans.empty? ? 1 : rowspan_rumit
  end

  def indikator_rencana_aksi_opd(sasaran)
    indikator = sasaran&.indikator_sasarans&.first
    rowspan = if sasaran.indikator_sasarans.length == 1
                sasaran.rencana_aksi_opds.empty? ? 1 : sasaran.rencana_aksi_opds.length
              else
                1
              end
    "
      <td rowspan='#{rowspan}' class='text-wrap indikator-sasaran'>#{indikator&.indikator_kinerja}</td>
      <td rowspan='#{rowspan}' class='text-center indikator-sasaran'>#{indikator&.target}</td>
      <td rowspan='#{rowspan}' class='text-center indikator-sasaran'>#{indikator&.satuan}</td>
    ".html_safe
  end

  def row_indikator_rencana_aksi_opd(sasaran)
    rowspan = sasaran.rencana_aksi_opds.empty? ? 1 : sasaran.rencana_aksi_opds.size
    sasaran.indikator_sasarans.drop(1).map do |indikator_s|
      if indikator_s == sasaran.indikator_sasarans.last
        "
        <tr class='last indikator-sasaran skip'>
          <td rowspan='#{rowspan}' class='text-wrap'>#{indikator_s.indikator_kinerja}</td>
          <td rowspan='#{rowspan}' class='text-center'>#{indikator_s.target}</td>
          <td rowspan='#{rowspan}' class='text-center'>#{indikator_s.satuan}</td>
        </tr>
      ".html_safe
      else
        "
        <tr class='indikator-sasaran skip'>
          <td rowspan='#{rowspan}' class='text-wrap'>#{indikator_s.indikator_kinerja}</td>
          <td rowspan='#{rowspan}' class='text-center'>#{indikator_s.target}</td>
          <td rowspan='#{rowspan}' class='text-center'>#{indikator_s.satuan}</td>
        </tr>
      ".html_safe
      end
    end
  end

  # rubocop: disable Metric/MethodLength
  def renaksi_opd_sync_jadwal_button(renaksi_opd, tahun, kode_opd, sasaran, index)
    button_to rencana_aksi_opd_path(renaksi_opd),
              params: {
                rencana_aksi_opd: {
                  tahun: tahun,
                  kode_opd: kode_opd,
                  i: index,
                  sasaran_id: sasaran.id
                }
              },
              class: 'btn btn-sm btn-primary w-100',
              remote: true,
              method: :patch,
              form: {
                data: {
                  controller: 'form-ajax',
                  form_ajax_with_modal_value: false,
                  form_ajax_target_param: dom_id(sasaran),
                  form_ajax_type_param: '',
                  action: 'ajax:complete->form-ajax#processAjax'
                }
              },
              data: {
                disable_with: "<i class='fa fa-sync fa-spin'></i>  Sedang sinkronisasi..."
              } do
      "<i class='fas fa-sync me-2'></i> <span>Sync Jadwal</span>".html_safe
    end
  end

  def renaksi_opd_delete_button(renaksi_opd, tahun, kode_opd, sasaran, index)
    button_to rencana_aksi_opd_path(renaksi_opd),
              params: {
                rencana_aksi_opd: {
                  tahun: tahun,
                  kode_opd: kode_opd,
                  i: index,
                  sasaran_id: sasaran.id
                }
              },
              class: 'btn btn-sm btn-outline-danger w-100',
              remote: true,
              method: :delete,
              form: {
                data: {
                  controller: 'form-ajax',
                  form_ajax_with_modal_value: false,
                  form_ajax_target_param: dom_id(sasaran),
                  form_ajax_type_param: 'total_replace',
                  form_ajax_confirm_title_value: "Renaksi '#{renaksi_opd}' akan dihapus.",
                  action: 'ajax:beforeSend->form-ajax#confirmAction ajax:complete->form-ajax#processAjax'
                }
              },
              data: {
                disable_with: "<i class='fa fa-sync fa-spin'></i>  Menghapus..."
              } do
      "<i class='fas fa-trash me-2'></i> <span>Hapus</span>".html_safe
    end
  end

  def subkegiatan_indikator_renaksi(renaksi_opd, tahun, kode_opd)
    subkegiatan = renaksi_opd.subkegiatan_renaksi
    tahun_n = tahun_fix(tahun)
    indikator = subkegiatan&.indikator_subkegiatan_tahun(tahun_n, kode_opd)
    "
      <td style='min-width: 200px;' class='border border-bottom-0 text-wrap fw-bolder skip'>#{subkegiatan&.nama_subkegiatan}</td>
      <td style='min-width: 100px;' class='border border-bottom-0 text-wrap fw-bolder'>#{indikator&.dig(:indikator)}</td>
      <td style='min-width: 50px;' class='border border-bottom-0 text-wrap fw-bolder'>#{indikator&.dig(:target)}</td>
      <td style='min-width: 50px;' class='border border-bottom-0 text-wrap fw-bolder'>#{indikator&.dig(:satuan)}</td>
    ".html_safe
  end

  def subkegiatan_indikator_renaksi_cetak(renaksi_opd, tahun, kode_opd)
    subkegiatan = renaksi_opd.subkegiatan_renaksi
    tahun_n = tahun_fix(tahun)
    indikator = subkegiatan&.indikator_subkegiatan_tahun(tahun_n, kode_opd)
    "
      <td style='min-width: 200px;' class='border border-bottom-0 text-wrap fw-bolder skip'>#{subkegiatan&.nama_subkegiatan}</td>
    ".html_safe
  end

  def flag_renaksi_buttons(renaksi_opd, tahun, kode_opd, sasaran, index)
    flag_merah = flag_perintah_walikota(renaksi_opd, tahun, kode_opd, sasaran, index)
    [flag_merah]
  end

  def flag_perintah_walikota(renaksi_opd, tahun, kode_opd, sasaran, index)
    button_text = if renaksi_opd.perintah_walikota?
                    "<i class='fas fa-times me-2'></i> <span>Batalkan Flag Perintah Walikota</span>"
                  else
                    "<i class='fas fa-check me-2 text-primary'></i> <span class='text-primary'>Aktifkan Flag Perintah Walikota</span>"
                  end
    button_to toggle_sasarans_is_perintah_walikota_rencana_aksi_opd_path(renaksi_opd),
              params: {
                rencana_aksi_opd: {
                  tahun: tahun,
                  kode_opd: kode_opd,
                  i: index,
                  sasaran_id: sasaran.id
                }
              },
              class: 'btn btn-sm btn-outline-danger w-100',
              remote: true,
              method: :patch,
              form: {
                data: {
                  controller: 'form-ajax',
                  form_ajax_with_modal_value: false,
                  form_ajax_target_param: dom_id(sasaran),
                  form_ajax_type_param: '',
                  form_ajax_confirm_title_value: "Renaksi '#{renaksi_opd}' akan di flag sebagai Perintah Walikota.",
                  action: 'ajax:beforeSend->form-ajax#confirmAction ajax:complete->form-ajax#processAjax'
                }
              },
              data: {
                disable_with: "<i class='fa fa-sync fa-spin'></i>  Updating..."
              } do
      button_text.html_safe
    end
  end
end
