import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ["show", "indikators"]

  toggleDetail(e) {
    const button = e.target
    const display = !e.params.show
    const details = this.indikatorsTargets
    this.showDetail(display, button)
    details.forEach(e => e.classList.toggle('d-none'))
    button.dataset.tableTematikShowParam = display
  }

  showDetail(display, button) {
    if (display) {
      button.classList.remove('btn-outline-primary')
      button.classList.add('btn-outline-danger')
      button.innerText = 'Sembunyikan'
    }
    else {
      button.classList.remove('btn-outline-danger')
      button.classList.add('btn-outline-primary')
      button.innerText = 'Tampilkan Indikator'
    }
  }


}
