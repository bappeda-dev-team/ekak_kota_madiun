module BpmnSpbesHelper
  def hitung_jumlah_bpmn(bpmn_spbes)
    bisa_digunakan = bpmn_spbes.count { |b| b.dapat_digunakan_pd_lain }
    harus_disusun = bpmn_spbes.count { |b| !b.dapat_digunakan_pd_lain }

    sudah_disusun = bpmn_spbes.count { |b| b.file_bpmn.attached? }
    belum_disusun = harus_disusun - bpmn_spbes.count { |b| !b.file_bpmn.attached? }

    {
      bisa_digunakan_opd_lain: bisa_digunakan,
      harus_disusun: harus_disusun,
      sudah_disusun: sudah_disusun,
      belum_disusun: belum_disusun
    }
  end
end
