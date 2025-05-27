import { Controller } from "stimulus";

export default class extends Controller {
  static targets = ["outputData", "data-dan-informasi"]

  // connect() {
  //     const outputDataField = this.outputDataTarget
  //     console.log(outputDataField)
  // }

  toggleDataDanInformasiField(e) {
    const checkboxValue = e.currentTarget.value
    const outputDataField = this.outputDataTarget
    const textarea = outputDataField.querySelector('textarea');

    if(spbeChecked(checkboxValue)) {
      outputDataField.classList.toggle('d-none')
      textarea.disabled = false;
    } else {
      textarea.disabled = true;
    };
  }


}

function spbeChecked(checkboxValue) {
  return typeof checkboxValue === 'string' && checkboxValue === 'spbe/pemdigi';

}
