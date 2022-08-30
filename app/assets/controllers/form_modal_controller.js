import { Controller } from 'stimulus'

//need sweet alert import

export default class extends Controller {
  static targets = ['location']

  closeModal(event) {
    console.log('modal closed')
  }

  appendForm(event) {
    const [data, status, xhr] = event.detail
    // append form to modal target
    console.log(status)
  }
}
