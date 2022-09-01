import { Controller } from 'stimulus'

//need sweet alert import

export default class extends Controller {
  static targets = ['isu_strategis']

  static values = {
    target: String
  }

  closeModal(event) {
    console.log('modal closed')
  }

  updateTargetValue(event) {
   const content = event.detail
   this.isu_strategisTarget.innerHTML = content.data
   console.log(content)
   console.log(this.isu_strategisTarget)
  }

  appendForm(event) {
    const target = event.currentTarget
    let location = event.params.location
    let result_target = event.params.target
    this.formFetcher(target.href, location)
  }

  formFetcher(url,target) {
    fetch(url)
            .then((res) => res.text())
            .then((html) => {
                        document.getElementById(target).innerHTML = html
                    });
  }
}
