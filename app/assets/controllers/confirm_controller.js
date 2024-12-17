import { Controller } from "stimulus";
import Swal from "sweetalert2";

export default class extends Controller {
  static targets = ["btn"];
  static values = {
    message: String,
    description: String,
    icon: String,
    confirm: String,
    cancel: String,
    method: String,
    isRemote: Boolean,
  };

  showConfirmationDialog() {
    const element = this.element;
    console.log(element);
    const message = this.messageValue;
    const text = this.descriptionValue;
    const icon = this.iconValue;
    const confirm = this.confirmValue;
    const cancel = this.cancelValue;

    Swal.fire({
      title: message || "Awas !",
      text: text || "",
      icon: icon || "warning",
      showCancelButton: true,
      confirmButtonText: confirm || "Ya",
      cancelButtonText: cancel || "Tidak",
    }).then((result) => this.confirmed(element, result));
  }

  confirmed(element, result) {
    console.log("confirm");
    const isRemote = this.isRemoteValue;
    // If result `success`
    if (result.value) {
      if (isRemote) {
        let reloadAfterSuccess = true;
        let token = $('meta[name="csrf-token"]').attr("content");
        $.ajax({
          beforeSend: function (xhr) {
            xhr.setRequestHeader("X-CSRF-Token", token);
          },
          method: this.methodValue || "GET",
          url: element.getAttribute("href"),
          dataType: "json",
          success: function () {
            Swal.fire("Success!", "", "success").then(() => {
              if (reloadAfterSuccess) {
                window.location.reload();
              }
            });
          },
          error: function (xhr) {
            let title = "Error!";
            let message = "Terjadi kesalahan";

            if (xhr.responseJSON && xhr.responseJSON.message) {
              message = xhr.responseJSON.message;
            }

            Swal.fire(title, message, "error");
          },
        });
      } else {
        console.log("horrible");
        element.removeAttribute("data-confirm-swal");
        element.click();
      }
    }
  }
}
