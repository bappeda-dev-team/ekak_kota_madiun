module AksisHelper
  def aksi_di_bulan(sasaran, tahapan, bulan)
    aksi = tahapan.aksis.find_by(bulan: bulan)
    if aksi
      target_dengan_bulan(sasaran, tahapan, aksi, bulan)
    else
      target_tanpa_bulan(sasaran, tahapan, bulan)
    end
  end

  def realisasi_di_bulan(sasaran, tahapan, bulan)
    aksi = tahapan.aksis.find_by(bulan: bulan)
    if aksi
      if aksi.realisasi
        return realisasi_dengan_isi(sasaran, tahapan, aksi, bulan)
      else
        return realisasi_tanpa_isi(sasaran, tahapan, aksi, bulan)
      end
    end
    "<td class='fw-bolder text-gray-500 border'></td>".html_safe
  end

  private

  def target_tanpa_bulan(sasaran, tahapan, bulan)
    "<td class='fw-bolder text-gray-500 border'>
      #{link_to('+', new_sasaran_tahapan_aksi_path(sasaran, tahapan, bulan: bulan),
                remote: true, data: { 'bs-toggle': 'modal', 'bs-target': '#form-aksi-target' })}
    </td>".html_safe
  end

  def target_dengan_bulan(sasaran, tahapan, aksi, bulan)
    "<td class='fw-bolder text-gray-500 border'>
      #{link_to(aksi.target, edit_sasaran_tahapan_aksi_path(sasaran, tahapan, aksi.id, bulan: bulan),
                remote: true, data: { 'bs-toggle': 'modal', 'bs-target': '#form-aksi-target' })}
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
end
