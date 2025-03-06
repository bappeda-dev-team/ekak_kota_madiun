module AksisHelper
  def aksi_di_bulan(sasaran, tahapan, bulan, disabled: false)
    target_tanpa_bulan(sasaran, tahapan, bulan, disabled)
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

  def target_link(sasaran, tahapan, bulan, aksi = nil)
    target = aksi.nil? ? '+' : aksi.to_s
    link = if aksi.nil?
             new_sasaran_tahapan_aksi_path(sasaran, tahapan,
                                           bulan: bulan)
           else
             edit_sasaran_tahapan_aksi_path(sasaran, tahapan,
                                            aksi, bulan: bulan)
           end
    link_to(link,
            remote: true,
            data: {
              controller: 'form-modal',
              action: 'form-modal#appendForm',
              form_modal_location_param: 'form-modal-body',
              bs_target: '#form-modal',
              bs_toggle: 'modal'
            }) do
      "<span class='aksi-bulan-#{bulan}' data-jumlah-aksi='#{target}'>#{target}</span>".html_safe
    end
  end

  def target_tanpa_bulan(sasaran, tahapan, bulan, _disabled)
    aksi = tahapan.aksis.find_by(bulan: bulan)
    "<td class='fw-bolder text-dark border' id='#{id_aksi(tahapan, bulan)}'>
       #{target_link(sasaran, tahapan, bulan, aksi)}
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
