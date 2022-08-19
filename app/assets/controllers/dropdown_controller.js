import { Controller } from 'stimulus'
import $ from 'jquery'


import Select2 from "select2";

export default class extends Controller {
   static targets = ["dropdown_element"]
   static values = {
    jenis: String,
    parent: String,
    url: String
  }
   get select() {
    return $(this.dropdown_elementTarget);
   }

  get default_options() {
    let options = { width: "100%", theme: "bootstrap-5" }
    return options
  }
  
  initialize() {
    this.jenis_dropdown_generator()
  }

  connect() {
    this.select.select2(this.default_options);
  }

  disconnect() {
    this.select.select2('destroy');
  }
  
  jenis_dropdown_generator() {
    let jenis = this.jenisValue
    switch(jenis) {
      case 'opd':
        console.log('opd')
        break
      case 'tahun':
        console.log('tahun')
        break
      default:
        console.log('default')
    }
  }

  dropdown_with_ajax(url) {
    let options = {
        width: "100%",
        theme: "bootstrap-5",
        url: this.urlValue,
        data: (params) => ({q: params.term}),
        delay: 2500
      }
    return options
  }
}
