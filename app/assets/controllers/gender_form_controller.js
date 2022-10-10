import { Controller } from 'stimulus'


export default class extends Controller {

  static targets = [ "sasaran", "penerima_manfaat", "data_terpilah", "penyebab_internal", "penyebab_external" ]

  connect() {
    console.log('hello, world')
  }

  find_data(event) {
    console.log(event.detail.data)
    let id_sasaran = event.detail.data.id
    console.log(id_sasaran)
    const data_sasaran = fetch(`/sasarans/${id_sasaran}/data_detail.json`)
      .then(response => response.json())
      .then((data) => {
        this.sasaranTarget.value = data.sasaran_kinerja
        this.penerima_manfaatTarget.value = data.penerima_manfaat
        this.data_terpilahTarget.value = data.data_terpilah
        this.penyebab_internalTarget.value = data.penyebab_internal
        this.penyebab_externalTarget.value = data.penyebab_external
      })
  }
}
