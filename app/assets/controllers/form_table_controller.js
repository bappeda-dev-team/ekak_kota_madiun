import { Controller } from "stimulus";
import Swal from "sweetalert2";

export default class extends Controller {
  static targets = ["table", "saveBtn", "editBtn"];
  static values = { isInput: Boolean };

  toggleInput(e) {
    this.isInputValue = !this.isInputValue;

    this.saveBtnTarget.classList.toggle("d-none");
    this.editBtnTarget.classList.toggle("btn-outline-danger")
    this.editBtnTarget.innerHTML = this.isInputValue
      ? `<i class="fas fa-times me-2"></i>Batal`
      : `<i class="fas fa-pencil-alt me-2"></i>Edit`;

    console.log('now inputing...')
  }

  saveData(e) {
    console.log('saved')
  }
}
