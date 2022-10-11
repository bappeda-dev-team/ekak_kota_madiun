import { Controller } from 'stimulus'


export default class extends Controller {

  static targets = [ "sasaran", "penerima_manfaat", "data_terpilah", "penyebab_internal", "penyebab_external",
                    "indikator_sasaran", "target_indikator", "satuan_indikator", "rencana_aksi" ]

  fill_data(event) {
    let id_sasaran = event.detail.data.id
    const data_sasaran = fetch(`/sasarans/${id_sasaran}/data_detail.json`)
      .then(response => response.json())
      .then((data) => {
        const indikator_sasaran = data.indikators
        this.sasaranTargets.forEach((sasaran) => {
          sasaran.value = data.sasaran_kinerja
        })
        this.penerima_manfaatTargets.forEach((penerima_manfaat) => {
          penerima_manfaat.value = data.penerima_manfaat
        })
        this.data_terpilahTargets.forEach((data_terpilah) => {
          data_terpilah.value = data.data_terpilah
        })
        this.penyebab_internalTarget.value = data.penyebab_internal
        this.penyebab_externalTarget.value = data.penyebab_external
        this.indikator_sasaranTarget.value = indikator_sasaran[0].indikator 
        this.target_indikatorTarget.value = indikator_sasaran[0].target 
        this.satuan_indikatorTarget.value = indikator_sasaran[0].satuan 
      })
    // data rencana aksi
    const data_rencana_aksi = fetch(`/sasarans/${id_sasaran}/rencana_aksi`)
                              .then((res) => res.text())
      .then((html) => {
        console.log(html)
        this.rencana_aksiTarget.innerHTML = html
      })
  }
}
