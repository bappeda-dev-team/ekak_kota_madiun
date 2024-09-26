import Rails from "@rails/ujs";
import Swal from "sweetalert2";
import "sweetalert2/src/sweetalert2.scss";

window.Swal = Swal;

// Behavior after click to confirm button
const confirmed = (element, result) => {
  // If result `success`
  if (result.value) {
    if (!element.getAttribute("data-remote")) {
      let reloadAfterSuccess = true;
      let token = $('meta[name="csrf-token"]').attr("content");
      $.ajax({
        beforeSend: function (xhr) {
          xhr.setRequestHeader("X-CSRF-Token", token);
        },
        method: element.getAttribute("data-method") || "GET",
        url: element.getAttribute("href"),
        dataType: "json",
        success: function (result) {
          Swal.fire("Success!", "", "success").then(() => {
            if (reloadAfterSuccess) {
              window.location.reload();
            }
          });
        },
        error: function (xhr) {
          let title = "Error!";
          let message = "Something went wrong. Please try again later.";

          if (xhr.responseJSON && xhr.responseJSON.message) {
            message = xhr.responseJSON.message;
          }

          Swal.fire(title, message, "error");
        },
      });
    } else {
      element.removeAttribute("data-confirm-swal");
      element.click();
    }
  }
};

// Display the confirmation dialog
const showConfirmationDialog = (element) => {
  const message = element.getAttribute("data-confirm-swal");
  const text = element.getAttribute("data-text");
  const icon = element.getAttribute("data-icon");
  const alert_only = element.getAttribute("data-alert-only");
  if (alert_only == "true") {
    Swal.fire({
      title: message || "Are you sure?",
      text: text || "",
      icon: icon || "warning",
      showCancelButton: false,
      confirmButtonText: "Ok",
    });
    return;
  }

  Swal.fire({
    title: message || "Awas !",
    text: text || "",
    icon: icon || "warning",
    showCancelButton: true,
    confirmButtonText: "Ya",
    cancelButtonText: "Tidak",
  }).then((result) => confirmed(element, result));
};

const allowAction = (element) => {
  if (element.getAttribute("data-confirm-swal") === null) {
    return true;
  }

  showConfirmationDialog(element);
  return false;
};

function handleConfirm(element) {
  if (!allowAction(this)) {
    Rails.stopEverything(element);
  }
}

Rails.delegate(document, "a[data-confirm-swal]", "click", handleConfirm);
Rails.delegate(document, "input[data-confirm-swal]", "click", handleConfirm);
Rails.delegate(document, "button[data-confirm-swal]", "click", handleConfirm);
