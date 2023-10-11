import { Controller } from 'stimulus'


export default class extends Controller {

  changeKode(e) {
    const { data } = e.detail
    if (data !== undefined) {
      const kode = data.kode
      this.element.value = kode
    }
    else {
      console.error('terjadi kesalahan')
    }
  }
}
