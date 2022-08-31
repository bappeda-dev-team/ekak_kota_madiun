import { Controller } from 'stimulus'

//need sweet alert import

export default class extends Controller {
  // static targets = ['location']

  closeModal(event) {
    console.log('modal closed')
  }

  appendForm(event) {
    const target = event.currentTarget
    let location = event.params.location
    let result_target = event.params.target
    this.formFetcher(target.href, location)
    let dispaEvent = this.dispatch("appendForm", { detail: { content: result_target } })
  }

  formFetcher(url,target) {
    fetch(url)
            .then((res) => res.text())
            .then((html) => {
                        document.getElementById(target).innerHTML = html
                    });
  }
}
