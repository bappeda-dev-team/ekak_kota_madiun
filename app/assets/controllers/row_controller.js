import { Controller } from "stimulus";
import Swal from "sweetalert2";

export default class extends Controller {
  static values = {
    element: String,
  };

  addRow(e) {
    const [xhr, status] = e.detail;
    const targetRow = document.getElementById(this.elementValue);

    if (
      status == "OK" &&
      targetRow != null &&
      typeof targetRow != "undefined"
    ) {
      const html = xhr.response;
      targetRow.insertAdjacentHTML("beforeend", html);
    } else {
      this.sweetalertStatus(status.text, status);
    }
  }

  editRow(e) {
    const [xhr, status] = e.detail;
    const targetRow = this.element;

    if (
      status == "OK" &&
      targetRow != null &&
      typeof targetRow != "undefined"
    ) {
      const html = xhr.response;
      targetRow.classList.add("d-none");
      targetRow.insertAdjacentHTML("afterend", html);
    } else {
      console.log({ status });
    }
  }

  batal() {
    const targetRow = this.element;

    if (targetRow.previousElementSibling != null) {
      targetRow.previousElementSibling.classList.remove("d-none");
    }
    targetRow.remove();
  }

  processAjax(event) {
    const [message, status] = event.detail;
    const { resText, html_content } = JSON.parse(message.response);
    const targetRow = this.element;

    if (status == "OK") {
      targetRow.outerHTML = html_content;
      this.animateBackground(targetRow);
    } else {
      this.sweetalertStatus(resText, status);
    }
  }

  animateBackground(target) {
    target.animate(
      [
        {
          //from
          backgroundColor: "rgba(242, 245, 169, 1)",
        },
        {
          //to
          backgroundColor: "rgba(242, 245, 169, 0.8)",
        },
      ],
      10000,
    );
  }

  sweetalertStatus(text, status) {
    if (status == "Accepted") {
      Swal.fire({
        title: "Sukses",
        text: text,
        icon: "success",
        confirmButtonText: "Ok",
      });
    } else if (status == "OK") {
      Swal.fire({
        title: "Sukses",
        text: text,
        icon: "success",
        confirmButtonText: "Ok",
      });
    } else if (status == "Created") {
      Swal.fire({
        title: "Sukses",
        text: text,
        icon: "success",
        confirmButtonText: "Ok",
      });
    } else {
      Swal.fire({
        title: "Gagal",
        text: text,
        icon: "error",
        confirmButtonText: "Ok",
      });
    }
  }
}
