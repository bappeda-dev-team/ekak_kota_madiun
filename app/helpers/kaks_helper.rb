module KaksHelper
  def link_show_kak(kak_id, tahun_sasaran)
    link_to "/acuan_kerja_new/#{kak_id}/#{tahun_sasaran}", class: "m-3" do
      '<i class="fas fa-book-open" data-bs-toggle="tooltip" data-bs-placement="bottom" title="Show item"></i>'.html_safe
    end
  end

  def link_pdf_kak(kak_id, tahun_sasaran)
    link_to "/pdf_kak/#{kak_id}/#{tahun_sasaran}.pdf", class: "m-3" do
      '<span class="far fa-file-pdf" data-bs-toggle="tooltip" data-bs-placement="bottom" title="Cetak KaK"></span>'.html_safe
    end
  end

  def anggaran_subkegiatan_kak(sasarans)
    number_with_delimiter(sasarans.map(&:total_anggaran).compact.sum) || 0
  end

  def button_edit(status, current_user, show_sasaran)
    if status == 'draft'
      link_to user_sasaran_path(current_user, show_sasaran), class: "btn btn-sm btn-info" do
        '<i class="fa fa-pencil-alt me-2" data-bs-toggle="tooltip" data-bs-placement="bottom" title="isi usulan"></i>
                    Isi Usulan'.html_safe
      end
    else
      '<button class="btn btn-sm btn-danger" disabled>
                    <i class="fa fa-times me-2" data-bs-toggle="tooltip" data-bs-placement="bottom" title="sudah diajukan"></i>
                    Sudah diajukan
                    </button>'.html_safe
    end
  end
end
