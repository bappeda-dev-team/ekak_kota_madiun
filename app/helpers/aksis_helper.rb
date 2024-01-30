module AksisHelper
  def aksi_di_bulan(sasaran, tahapan, bulan, disabled: false)
    aksi = tahapan.aksis.find_by(bulan: bulan)
    if aksi
      target_dengan_bulan(sasaran, tahapan, aksi, bulan, disabled)
    else
      target_tanpa_bulan(sasaran, tahapan, bulan, disabled)
    end
  end

  def realisasi_di_bulan(sasaran, tahapan, bulan)
    aksi = tahapan.aksis.find_by(bulan: bulan)
    if aksi
      return realisasi_dengan_isi(sasaran, tahapan, aksi, bulan) if aksi.realisasi

      return realisasi_tanpa_isi(sasaran, tahapan, aksi, bulan)

    end
    "<td class='fw-bolder text-gray-500 border'></td>".html_safe
  end

  private

  def target_disabled
    "<td class='fw-bolder text-danger border'>
      <i class='fa fa-times'></i>
    </td>".html_safe
  end

  def target_tanpa_bulan(sasaran, tahapan, bulan, disabled)
    "<td class='fw-bolder text-dark border'>
      #{ if disabled
           '-'
         else
           link_to('+', new_sasaran_tahapan_aksi_path(sasaran, tahapan, bulan: bulan),
                   remote: true, data: { 'bs-toggle': 'modal', 'bs-target': '#form-aksi-target' })
         end
      }
    </td>".html_safe
  end

  def target_dengan_bulan(sasaran, tahapan, aksi, bulan, disabled)
    "<td class='fw-bolder text-gray-500 border'>
      #{ if disabled
           aksi.target
         else
           link_to(aksi.target, edit_sasaran_tahapan_aksi_path(sasaran, tahapan, aksi.id, bulan: bulan),
                   remote: true, data: { 'bs-toggle': 'modal', 'bs-target': '#form-aksi-target' })
         end
      }
    </td>".html_safe
  end

  def realisasi_tanpa_isi(sasaran, tahapan, aksi, bulan)
    "<td class='fw-bolder text-gray-500 border'>
      #{link_to('+', edit_sasaran_tahapan_aksi_path(sasaran, tahapan, aksi.id, bulan: bulan, type: 'realisasi'),
                remote: true, data: { 'bs-toggle': 'modal', 'bs-target': '#form-aksi-realisasi' })}
    </td>".html_safe
  end

  def realisasi_dengan_isi(sasaran, tahapan, aksi, bulan)
    "<td class='fw-bolder text-gray-500 border'>
      #{link_to(aksi.realisasi, edit_sasaran_tahapan_aksi_path(sasaran, tahapan, aksi.id, bulan: bulan, type: 'realisasi'),
                remote: true, data: { 'bs-toggle': 'modal', 'bs-target': '#form-aksi-realisasi' })}
    </td>".html_safe
  end

  def sesuai?(checker)
    if checker
      "<i class='fa fa-check text-success'></i>".html_safe
    else
      "<span class='badge bg-danger'><i class='fa fa-times'></i> Belum terisi</span>".html_safe
    end
  end

  def target_sesuai?(checker)
    if checker
      "<i class='fa fa-check text-success'></i>".html_safe
    else
      "<span class='badge bg-danger'><i class='fa fa-times'></i> Rencana aksi belum 100%</span>".html_safe
    end
  end
end
