module SasaransHelper
  def diajukan?
    @sasaran.status == 'pengajuan' || @sasaran.status == 'disetujui'
  end

  def status_sasaran(status)
    status_map = {
      :pengajuan => "<button class='btn btn-info d-inline-flex align-items-center'>
      Pengajuan
      <i class='far fa-paper-plane icon icon-xs ms-2'></i>
      </button>".html_safe,
      :disetujui => "<button class='btn btn-success d-inline-flex align-items-center'>
      Disetujui
      <i class='far fa-check-circle icon icon-xs ms-2'></i>
      </button>".html_safe,
      :ditolak => "<button class='btn btn-danger d-inline-flex align-items-center'>
      Ditolak
      <i class='fas fa-times-circle icon icon-xs ms-2'></i>
      </button>".html_safe,
      :draft => "<button class='btn btn-secondary d-inline-flex align-items-center'>
      Draft
      <i class='far fa-clipboard icon icon-xs ms-2'></i>
      </button>".html_safe
    }.freeze
    status_map[status.to_sym]
  end
end
