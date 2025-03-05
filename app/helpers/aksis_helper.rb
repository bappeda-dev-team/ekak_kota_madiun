module AksisHelper
  def aksi_di_bulan(sasaran, tahapan, bulan, disabled: false)
    aksi = tahapan.aksis.find_by(bulan: bulan)
    if aksi
      target_dengan_bulan(sasaran, tahapan, aksi, bulan, disabled)
    else
      target_tanpa_bulan(sasaran, tahapan, bulan, disabled)
    end
  end

  def id_aksi(tahapan, bulan)
    dom_id(tahapan, "aksi-#{bulan}")
  end

  private

  def target_disabled
    "<td class='fw-bolder text-danger border'>
      <i class='fa fa-times'></i>
    </td>".html_safe
  end

  def target_tanpa_bulan(sasaran, tahapan, bulan, disabled)
    "<td class='fw-bolder text-dark border' id='#{id_aksi(tahapan, bulan)}'>
      #{ if disabled
           '-'
         else
           link_to('+', new_sasaran_tahapan_aksi_path(sasaran, tahapan, bulan: bulan),
                   remote: true,
                   data: {
                     controller: 'form-modal',
                     action: 'form-modal#appendForm',
                     form_modal_location_param: 'form-modal-body',
                     bs_target: '#form-modal',
                     bs_toggle: 'modal'
                   })
         end
      }
    </td>".html_safe
  end

  def target_dengan_bulan(sasaran, tahapan, aksi, bulan, disabled)
    "<td class='fw-bolder text-gray-500 border' id='#{id_aksi(tahapan, bulan)}'>
      #{ if disabled
           aksi.target
         else
           link_to(aksi.target, edit_sasaran_tahapan_aksi_path(sasaran, tahapan, aksi.id, bulan: bulan),
                   remote: true,
                   data: {
                     controller: 'form-modal',
                     action: 'form-modal#appendForm',
                     form_modal_location_param: 'form-modal-body',
                     bs_target: '#form-modal',
                     bs_toggle: 'modal'
                   })
         end
      }
    </td>".html_safe
  end

  def sesuai?(checker)
    if checker
      "<i class='fa fa-check text-success'></i>".html_safe
    else
      "<span class='badge bg-danger'><i class='fa fa-times me-2'></i>BELUM SESUAI</span>".html_safe
    end
  end

  def target_sesuai?(checker)
    if checker
      "<i class='fa fa-check text-success'></i>".html_safe
    else
      "<span class='badge bg-danger'><i class='fa fa-times me-2'></i>RENCANA AKSI BELUM 100%</span>".html_safe
    end
  end
end
