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
                tahun: Number
        }

        connect() {
                const url = "/filter/kak_dashboard"
                // Build formData object.
                let formData = new FormData();
                formData.append('kode_opd', this.opdValue);
                formData.append('tahun', this.tahunValue);

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
                        );
        }
}

