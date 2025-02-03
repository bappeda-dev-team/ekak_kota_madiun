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

  def isi_subkegiatan?(user)
    user.eselon_user == 'eselon_4' || current_user.has_any_role?('eselon_4') ||
      user.nama_bidang&.upcase&.include?("PUSKESMAS") || user.opd.nama_opd&.upcase&.include?("BENCANA")
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
end
