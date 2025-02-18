import ApplicationController from "./application_controller";

export default class extends ApplicationController {
  static targets = ["tahunAwal", "tahunAkhir"];
  // static values = {
  //   elementId: String,
  //   withAlert: { type: Boolean, default: true },
  // };

  fillTahunPeriode(e) {
    const { data } = e.detail;
    const tahunAwal = data.tahun_awal
    const tahunAkhir = data.tahun_akhir

    this.fillTahunAwalValue(tahunAwal)
    this.fillTahunAkhirValue(tahunAkhir)
  }

  fillTahunAwalValue(tahun) {
    this.tahunAwalTarget.value = tahun
  }

  fillTahunAkhirValue(tahun) {
    this.tahunAkhirTarget.value = tahun
  }
}
