import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['results']

  append(event) {
    const [data, status, xhr] = event.detail;
    this.resultsTarget.innerHTML = xhr.response
  }
} 


