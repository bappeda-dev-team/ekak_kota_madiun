import { Controller } from "stimulus";
import Swal from "sweetalert2";

export default class extends Controller {
  static targets = ["table", "saveBtn", "editBtn", "formPlace", "formTable"];
  static values = {
    isInput: Boolean,
    url: String
  };

  toggleInput(e) {
    this.isInputValue = !this.isInputValue;
    // switch button
    this.saveBtnTarget.classList.toggle("d-none");
    this.editBtnTarget.classList.toggle("btn-outline-danger")
    this.editBtnTarget.innerHTML = this.isInputValue
      ? `<i class="fas fa-times me-2"></i>Batal`
      : `<i class="fas fa-pencil-alt me-2"></i>Edit`;

    if(this.isInputValue) {
      this.showForm(this.urlValue)
    } else {
      this.formTableTarget.remove()
      // show table
      this.tableTarget.classList.remove('d-none');
    }
  }

  async showForm(url) {
    const element = this.formPlaceTarget
    try {
      const response = await fetch(url, {
        headers: { "X-Requested-With": "XMLHttpRequest" },
      });

      if (response.ok) {
        const data = await response.json();
        const html = data.html_content
        element.insertAdjacentHTML("beforeend", html)
        // hide table
        this.tableTarget.classList.add('d-none');
      } else {
        const html =
          '<div class="alert alert-danger" role="alert" data-form-table-target="formTable">Terjadi Kesalahan</div>';
        element.insertAdjacentHTML("beforeend", html)
      }

    } catch (error) {
      console.error("Error fetching results:", error);
      const html =
          '<div class="alert alert-danger" role="alert" data-form-table-target="formTable">Terjadi Kesalahan</div>';
      element.insertAdjacentHTML("beforeend", html)
    }
  }

  saveData(e) {
    console.log('saved')
  }
}
