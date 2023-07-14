import { Controller } from 'stimulus'


export default class extends Controller {
  static targets = ["item"]

  connect() {
    const multi = this.itemTargets
    multi.forEach((e) => {
      let activeLinks = e.getElementsByClassName('active')
      let span = e.previousElementSibling
      if (activeLinks.length > 0) {
        span.classList.remove('collapsed')
        span.setAttribute("aria-expanded", true)
        e.classList.add('show')
        e.setAttribute("aria-expanded", true)
      }
    })

  }
}
