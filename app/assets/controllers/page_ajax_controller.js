// Visit The Stimulus Handbook for more details
// https://stimulusjs.org/handbook/introduction
//
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

import { Controller } from "stimulus";
// Simple DataTable
import "simple-datatables/src/style.css";
import { DataTable } from "simple-datatables";

export default class extends Controller {
  static targets = ["results"];
  static values = {
    opd: String,
    tahun: String,
    url: String,
    jenisUsulan: String,
    reqtype: { type: String, default: "POST" },
  };

  connect() {
    const url = this.urlValue;
    if (this.reqtypeValue == "POST") {
      this.fetcherPost(url);
    } else {
      this.fetcherGet(url);
    }
  }

  fetcherPost(url) {
    const token = document.head.querySelector(
      'meta[name="csrf-token"]',
    ).content;

    // Build formData object.
    let formData = new FormData();
    formData.append("kode_opd", this.opdValue);
    formData.append("tahun", this.tahunValue);
    formData.append("jenis", this.jenisUsulanValue);
    formData.append("authenticity_token", token);

    fetch(url, {
      body: formData,
      method: this.reqtypeValue,
    })
      .then((response) => response.text())
      .then((text) => {
        this.resultsTarget.innerHTML = text;
      })
      .then(() => {
        const $table = $("table.sticky-head");
        $table.floatThead({
          responsiveContainer: function ($table) {
            return $table.closest(".table-responsive");
          },
        });

        new DataTable("#data-table");
      })
      .catch((e) => {
        this.resultsTarget.innerHTML = "Terjadi Kesalahan";
      });
  }

  fetcherGet(url) {
    fetch(url)
      .then((response) => response.text())
      .then((text) => {
        this.resultsTarget.innerHTML = text;
      })
      .catch((e) => {
        this.resultsTarget.innerHTML = "Terjadi Kesalahan";
      });
  }
}
