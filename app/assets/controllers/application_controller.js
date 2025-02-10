import { Controller } from "stimulus";
import { Modal } from "bootstrap";
import Swal from "sweetalert2";

export default class extends Controller {
  // hide default bootstrap modal
  // with id = form-modal
  // modalName is standardize in layout/application.html.erb
  modalHider(modalName = "form-modal") {
    const modal = document.getElementById(modalName);
    Modal.getInstance(modal).hide();
  }

  // fire default success alert
  sweetAlertSuccess(text) {
    Swal.fire({
      title: "Sukses",
      text: text,
      icon: "success",
      confirmButtonText: "Ok",
    });
  }

  // fire default failed alert
  sweetAlertFailed(text) {
    Swal.fire({
      title: "Gagal",
      text: text,
      icon: "error",
      confirmButtonText: "Ok",
    });
  }
}
