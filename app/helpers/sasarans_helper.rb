module SasaransHelper
  def diajukan?
    @sasaran.status == 'pengajuan' || @sasaran.status == 'disetujui'
  end

  def status_sasaran(status) # rubocop:disable Metrics/MethodLength
    status_map = {
      pengajuan: "<button class='btn btn-info d-inline-flex align-items-center'>
      Pengajuan
      <i class='far fa-paper-plane icon icon-xs ms-2'></i>
      </button>".html_safe,
      disetujui: "<button class='btn btn-success d-inline-flex align-items-center'>
      Disetujui
      <i class='far fa-check-circle icon icon-xs ms-2'></i>
      </button>".html_safe,
      ditolak: "<button class='btn btn-danger d-inline-flex align-items-center'>
      Ditolak
      <i class='fas fa-times-circle icon icon-xs ms-2'></i>
      </button>".html_safe,
      draft: "<button class='btn btn-secondary d-inline-flex align-items-center'>
      Draft
      <i class='far fa-clipboard icon icon-xs ms-2'></i>
      </button>".html_safe
    }.freeze
    status_map[status.to_sym]
  end

  def status_helper(kak) # rubocop:disable Metrics/MethodLength
    if kak.sasarans.exists? status: 'draft'
      `<button class="btn btn-sm btn-danger" disabled>
          <i class="fas fa-times me-2"></i>
          ! Belum diajukan
        </button>`.html_safe
    elsif kak.sasarans.exists? status: 'pengajuan'
      `<%= link_to setujui_semua_sasaran_path(sasaran_diajukans: [kak.sasarans.pluck(:id)], dom: dom_id(kak), rowspan: row_dalam ),
        method: :post, remote: true,
        data: { disable_with: 'Memproses....'},
        class:"btn btn-sm btn-primary" do %>
        <i class="fas fa-lock me-2"></i>
        Kunci
      <% end %>`
    elsif kak.sasarans.exists? status: 'disetujui'
      `<%= link_to revisi_semua_sasaran_path(sasaran_diajukans: [kak.sasarans.pluck(:id)], dom: dom_id(kak), rowspan: row_dalam),
        method: :post, remote: true,
        data: { disable_with: 'Memproses....'},
        class:"btn btn-sm btn-info" do %>
        <i class="fas fa-lock-open me-2"></i>
        Buka Kuncian
      <% end %>`
    else
      `<button class="btn btn-sm btn-danger" disabled>
        <i class="fas fa-times me-2"></i>
        Ditolak
      </button>`.html_safe
    end
  end

  def sasaran_wajib_manrisk(sasaran)
    tahun_bener = sasaran.tahun[/[^_]\d*/, 0].to_i
    sasaran.strategi&.strategi_eselon4 && tahun_bener > 2024
  end

  def jenis_strategi_sasaran(role)
    case role
    when 'eselon_2'
      'strategic'
    when 'eselon_3'
      'tactical'
    when 'eselon_4'
      'operational'
    when 'staff'
      'staff'
    else
      'kosong'
    end
  end

  def status_pokin_kosong(strategi_sasaran)
    return unless strategi_sasaran == 'Kosong'

    '<span class="badge badge-lg bg-danger text-dark w-100">POHON KINERJA BELUM TERISI</span>'.html_safe
  end

  def status_sasaran_pokin(status_sasaran)
    if status_sasaran == 'siap_ditarik'
      '<span class="badge badge-lg bg-success w-100">SIAP DITARIK SKP</span>'.html_safe
    else
      '<span class="badge badge-lg bg-warning text-dark w-100">BELUM SIAP DITARIK SKP</span>'.html_safe
    end
  end

  def status_manrisk(status_manrisk)
    if status_manrisk == 'disetujui'
      '<span class="badge badge-lg bg-success w-100">MANRISK DISETUJUI</span>'.html_safe
    elsif %w[siap_dinilai ditolak].include?(status_manrisk)
      '<span class="badge badge-lg bg-warning text-dark w-100">MANRISK BELUM DIVERIFIKASI</span>'.html_safe
    else
      '<span class="badge badge-lg bg-danger w-100">MANRISK BELUM TERISI</span>'.html_safe
    end
  end

  def status_subkegiatan(subkegiatan)
    return if subkegiatan&.valid_kode_opd_subkegiatan

    '<span class="badge badge-lg bg-danger w-100">SUBKEGIATAN TIDAK VALID</span>'.html_safe
  end

  def isi_subkegiatan?(user)
    user.eselon_user == 'eselon_4' || current_user.has_any_role?('eselon_4') ||
      user.nama_bidang&.upcase&.include?("PUSKESMAS") || user.opd.nama_opd&.upcase&.include?("BENCANA")
  end

  def is_eselon4?(user, sasaran)
    isi_subkegiatan?(user) || sasaran.strategi&.strategi_eselon4
  end

  def sasaran_check(checker)
    if checker
      "<i class='fa fa-check text-success'></i>".html_safe
    else
      "<span class='badge bg-danger'><i class='fa fa-times'></i> Manual IK atau Indikator Belum terisi</span>".html_safe
    end
  end

  def strategi_valid_style(strategi)
    strategi.include?('dihapus') || strategi == 'Kosong' ? 'text-danger' : 'text-success'
  end

  def strategi_style(role_strategi)
    case role_strategi
    when 'eselon_2'
      'text-strategic'
    when 'eselon_3' || 'eselon_2b'
      'text-tactical'
    when 'eselon_4'
      'text-operational'
    else
      ''
    end
  end

  def toggle_inovasi_buttons(sasaran)
    lolos_btn = inovasi_lolos_button(sasaran)
    tolak_btn = inovasi_tolak_button(sasaran)
    batal_btn = inovasi_batal_button(sasaran)
    if sasaran.status_inovasi.blank? || sasaran.status_inovasi == 'batal'
      [lolos_btn, tolak_btn]
    else
      [batal_btn]
    end
  end

  def inovasi_lolos_button(sasaran)
    button_text = "<i class='fas fa-check me-2'></i> <span>Lolos</span>".html_safe
    render(ModalButtonComponent.new(path: penilaian_inovasi_sasaran_path(sasaran, status: 'lolos'),
                                    title: button_text,
                                    style: 'btn btn-sm btn-outline-success w-100',
                                    icon: false))
  end

  def inovasi_tolak_button(sasaran)
    button_text = "<i class='fas fa-times me-2'></i> <span>Tolak</span>".html_safe
    render(ModalButtonComponent.new(path: penilaian_inovasi_sasaran_path(sasaran, status: 'tolak'),
                                    title: button_text,
                                    style: 'btn btn-sm btn-outline-danger w-100',
                                    icon: false))
  end

  def inovasi_batal_button(sasaran)
    button_text = "<i class='fas fa-times me-2'></i> <span>Batalkan</span>"
    confirm_title_text = "akan menghapus status inovasi saat ini."
    button_to toggle_inovasi_lolos_sasaran_path(sasaran),
              params: {
                sasaran: {
                  inovasi_status: 'batal',
                  inovasi_level: '',
                  inovasi_catatan: ''
                }
              },
              class: 'btn btn-sm btn-danger w-100',
              remote: true,
              method: :patch,
              form: {
                data: {
                  controller: 'form-ajax',
                  form_ajax_with_modal_value: false,
                  form_ajax_target_param: dom_id(sasaran),
                  form_ajax_type_param: '',
                  form_ajax_confirm_title_value: confirm_title_text,
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
