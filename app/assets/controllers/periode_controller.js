import ApplicationController from "./application_controller";

export default class extends ApplicationController {
  static targets = ["tahunAwal", "tahunAkhir", "rangeTahun"];
  static values = {
    indikatorId: String,
    indexForm: Number
  };

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

  updateRangePeriode(e) {
    const { data } = e.detail;
    const tahunAwal = data.tahun_awal
    const tahunAkhir = data.tahun_akhir
    const indikatorId = this.indikatorIdValue
    const indexForm = this.indexFormValue

    // this.rangeTahunTarget.innerHTML = 'changed'
    // this.tahunAwalValue = tahunAwal
    // this.tahunAkhirValue = tahunAkhir

    // console.log(this.tahunAkhirValue)
    const url = `/tujuan_kota/target_indikator_fields?tahun_awal=${tahunAwal}&tahun_akhir=${tahunAkhir}&indikator_id=${indikatorId}&index_form=${indexForm}`

    fetch(url, { method: "get" })
      .then(response => response.text())
      .then((text) => {
        this.rangeTahunTargets.forEach((range) => {
          range.innerHTML = text;
        })
      })
      .catch(error => this.errorResponse(error))
  }
}
