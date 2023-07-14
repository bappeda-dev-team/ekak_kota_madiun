// Visit The Stimulus Handbook for more details 
// https://stimulusjs.org/handbook/introduction
// 
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

import { Controller } from "stimulus"
import { FetchRequest } from '@rails/request.js'


export default class extends Controller {
  static targets = ["output"]
  static values = {
    url: String
  }

  async refetch() {
    const url = this.urlValue
    const request = new FetchRequest('get', url)
    const response = await request.perform()
    if (response.ok) {
      const body = await response.text
      this.element.innerHtml = body
    } else {
      console.error('terjadi kesalahan !')
    }
  }
}
