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

  def status_sasaran_pokin(status_sasaran)
    if status_sasaran == 'siap_ditarik'
      'SIAP DITARIK SKP'
    else
      'BELUM SIAP DITARIK SKP'
    end
  end
end
