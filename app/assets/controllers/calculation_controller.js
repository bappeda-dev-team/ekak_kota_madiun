// Visit The Stimulus Handbook for more details
// https://stimulusjs.org/handbook/introduction
//
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["hitung"];
  static values = {
    parent: String,
    kode: String,
    jenis: String,
    anggaran: Object
  };

  calculate(findChilds) {
    const childs = document.querySelectorAll(`tr[data-calculation-parent-value='${findChilds}']`)
    let anggarans = []
    childs.forEach(el => {
      anggarans.push(el.getAttribute('data-calculation-anggaran-value'))
    })
    let result = {};
    anggarans.forEach(d => {
      let objectData = JSON.parse(d);
      Object.keys(objectData).forEach(key => {
        if (result.hasOwnProperty(key)) {
          result[key] += objectData[key];
        } else {
          result[key] = objectData[key];
        }
      });
    });

    return result;
  }

  what(event) {
    const findChilds = event.target.id
    const hasil = this.calculate(findChilds)
    this.anggaranValue = hasil
    const anggaran = this.anggaranValue
    this.hitungTargets.forEach(el => {
      const tahunEl = el.getAttribute('data-tahun')
      el.innerText = numberWithCommas(anggaran[tahunEl])
    })
  }

  sumTotal() {
    const parentUpdateTarget = document.getElementById(this.parentValue)
    this.dispatch('sumTotal', {
      target: parentUpdateTarget,
    })
  }
}
function numberWithCommas(x) {
  return x.toString().replace(/\B(?=(\d{3})+(?!\d))/g, ",");
}
