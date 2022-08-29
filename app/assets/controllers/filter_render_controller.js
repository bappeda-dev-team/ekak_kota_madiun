import { Controller } from 'stimulus'

export default class extends Controller {
  static targets = ['results']

  append(event) {
    const [data, status, xhr] = event.detail;
    console.log(xhr)
    this.resultsTarget.innerHTML = xhr.response
  }
} 


