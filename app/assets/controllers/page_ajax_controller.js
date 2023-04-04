// Visit The Stimulus Handbook for more details 
// https://stimulusjs.org/handbook/introduction
// 
// This example controller works with specially annotated HTML like:
//
// <div data-controller="hello">
//   <h1 data-target="hello.output"></h1>
// </div>

import { Controller } from "stimulus"

export default class extends Controller {
        static targets = ['results']
        static values = {
                opd: String,
                tahun: Number,
                url: String,
                jenisUsulan: String
        }

        connect() {
                const url = this.urlValue
                // Build formData object.
                let formData = new FormData();
                formData.append('kode_opd', this.opdValue);
                formData.append('tahun', this.tahunValue);
                formData.append('jenis', this.jenisUsulanValue);

                fetch(url,
                        {
                                body: formData,
                                method: "post"
                        })
                        .then(
                                response => response.text()
                        )
                        .then(
                                text => {
                                        this.resultsTarget.innerHTML = text
                                }
                        ).catch(
                                e => {
                                        this.resultsTarget.innerHTML = "Terjadi Kesalahan"
                                        console.log(e)
                                }

                        )
        }
}

