import Rails from "@rails/ujs";
import { Controller } from "stimulus";

export default class extends Controller {
  static targets = [
    "table",
    "anggaran",
    "penetapan",
    "cancel",
    "simpan",
    "formInput",
    "hapus",
    "form",
    "main",
  ];
  static values = {
    anggaran: Number,
  };

  editRow(e) {
    const [xhr, status] = e.detail;
    console.log(status);
    const targetRow = this.element;

    if (status == "OK") {
      const html = xhr.response;
      targetRow.outerHTML = html;
    } else {
      this.sweetalertStatus(status.text, status);
    }
  }

  processAjax(event) {
    // event.preventDefault()
    const [message, status] = event.detail;
    const { resText, html_content } = JSON.parse(message.response);
    const target = this.element.parentElement;
    if (status == "Unprocessable Entity") {
      const formElement = this.formTarget;
      formElement.innerHTML = html_content;
    } else {
      target.innerHTML = html_content;
      this.animateBackground(target);
      // target.replaceWith(html);
    }
    this.sweetalertStatus(resText, status);
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

  closeForm() {
    const formElement = this.formTarget;
    const mainElement = this.mainTarget;
    formElement.classList.toggle("d-none");
    formElement.innerHTML = "";
    mainElement.classList.toggle("d-none");
  }

  simpan() {
    this.toggleButton();
    const form = this.formTarget.querySelector("form");
    Rails.fire(form, "submit");
  }

  cancelForm() {
    this.toggleButton();
    this.formTarget.innerHTML = "";
  }

  toggleButton() {
    this.cancelTarget.classList.add("d-none");
    this.simpanTarget.classList.add("d-none");
    this.editTarget.classList.remove("d-none");
    this.hapusTarget.classList.remove("d-none");
    this.penetapanTarget.classList.remove("d-none");
    this.formTarget.classList.add("d-none");
  }

  onPostSuccess(event) {
    const result = event.detail;
    const [data, _status, _request] = result;

    const { anggaran, total, parent, jumlah } = data.results;
    this.penetapanTarget.innerHTML = anggaran;
    const totalPenetapan = document.getElementById(parent);
    const jumlahPenetapan = document.getElementById("totalPenetapan");
    totalPenetapan.innerHTML = total;
    jumlahPenetapan.innerHTML = jumlah;
    this.formTarget.innerHTML = "";
    this.element.classList.add("higlighted");
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
