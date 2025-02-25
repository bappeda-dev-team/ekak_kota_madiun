import ApplicationController from "./application_controller";
import { Modal } from "bootstrap";
import Turbolinks from "turbolinks";
import { get } from "@rails/request.js";

export default class extends ApplicationController {
  static targets = ["errorContainer", "button"];
  static values = {
    elementId: String,
    withAlert: { type: Boolean, default: true },
    tahun: String
  };

  async checkRecord(event) {
    if (this.element.dataset.skipCheck === "true") {
      this.element.dataset.skipCheck = "false"; // Reset for future submissions
      return;
    }

    event.preventDefault();

    const year = document.querySelector('#tahun_tujuan').value;
    if (!year) return;

    // Make an AJAX request to check if a record exists
    const response = await get(`/clone/program_unggulans_checker?tahun_tujuan=${year}`,
      { responseKind: "json" });

    if (response.ok) {
      const data = await response.json
      if (data.exists) {
        const result = await Swal.fire({
          title: "Data sudah ada",
          text: `Data Program Unggulan tahun ${data.tahun_check} sudah terisi. Lanjutkan?`,
          icon: "warning",
          showCancelButton: true,
          confirmButtonText: "Lanjutkan",
          cancelButtonText: "Batalkan",
          reverseButtons: true
        });

        if (!result.isConfirmed) {
          return; // Stop form submission if user cancels
        }
      }
    }

    this.element.dataset.skipCheck = "true";
    this.element.requestSubmit();
  }

  ajaxSuccess(e) {
    const [xhr] = e.detail;
    super.modalHider();
    super.sweetAlertSuccess(xhr.resText);
    if (this.hasElementIdValue) {
      this.partialAttacher(this.elementIdValue, xhr.attachmentPartial);
    }
  }

  ajaxSuccessAttach(e) {
    const [xhr] = e.detail;
    super.modalHider();
    super.sweetAlertSuccess(xhr.resText);
    if (this.hasElementIdValue) {
      const target = document.getElementById(this.elementIdValue);
      const html_element = xhr.attachmentPartial;
      target.innerHTML = html_element + target.innerHTML;
    }
  }

  ajaxDelete(e) {
    const [xhr] = e.detail;
    super.sweetAlertSuccess(xhr.resText);
    if (this.hasElementIdValue) {
      const target = document.getElementById(this.elementIdValue);
      target.remove();
    }
  }

  ajaxError(e) {
    const [xhr] = e.detail;
    super.sweetAlertFailed(xhr.resText);
    this.partialAttacher("form-modal-body", xhr.errors);
  }

  ajaxErrorAlert(e) {
    const [xhr] = e.detail;
    super.sweetAlertFailed(xhr.resText);
  }

  partialAttacher(targetName, html_element) {
    const target = document.getElementById(targetName);
    target.innerHTML = html_element;
  }

  processAjaxRedirect(event) {
    // refresh if success
    // if failed, attach server html to errorContainer id
    const [message, status] = event.detail;
    const { resText, html_content } = JSON.parse(message.response);
    if (status == "OK") {
      Swal.fire({
        title: "Sukses",
        text: resText,
        icon: "success",
        confirmButtonText: "Ok",
      }).then(() => {
        Turbolinks.visit(window.location, { action: "replace" });
      });
    } else if (status == "Service Unavailable") {
      const errContainer = document.getElementById("errorContainer");
      errContainer.classList.remove("d-none");
      errContainer.innerHTML = html_content;
    }
  }

  processAjax(event) {
    // event.preventDefault();
    const [message, status] = event.detail;
    const { resText, html_content } = JSON.parse(message.response);
    if (status == "Unprocessable Entity") {
      this.partialAttacher("form-modal-body", html_content);
    } else if (status == "Internal Server Error") {
      this.errorContainerTarget.classList.remove("d-none");
      this.errorContainerTarget.innerHTML = html_content;
    } else {
      const target = document.getElementById(event.params.target);

      // TODO: ubah ke switch case
      if (target != null && typeof target != "undefined") {
        if (event.params.type == "append") {
          target.insertAdjacentHTML("afterend", html_content);
          this.animateBackground(target.lastElementChild);
        } else if (event.params.type == "prepend") {
          target.insertAdjacentHTML("beforeend", html_content);
          this.animateBackground(target.lastElementChild);
        } else if (event.params.type == "afterbegin") {
          target.insertAdjacentHTML("afterbegin", html_content);
          this.animateBackground(target.firstChild);
        } else if (event.params.type == "nested") {
          const nestedRows = this.findNestedRow(target);
          nestedRows.forEach((e) => e.remove());
          target.outerHTML = html_content;
          const new_target = document.getElementById(event.params.target);
          const new_nesteds = this.findNestedRow(new_target);
          this.animateBackground(new_target);
          new_nesteds.forEach((e) => this.animateBackground(e));
        } else if (event.params.type == "replace_next") {
          target.nextElementSibling.remove();
          target.outerHTML = html_content;
        } else if (event.params.type == "total_replace") {
          target.outerHTML = html_content;
          const newTarget = document.getElementById(event.params.target);
          this.animateBackground(newTarget);
        } else {
          target.innerHTML = html_content;
          this.animateBackground(target);
        }
      }
      if (this.withAlertValue) {
        this.sweetalertStatus(resText, status);
      }
      const modal = event.params.modal;
      if (modal != null && typeof modal != "undefined") {
        super.modalHider(modal);
      } else {
        super.modalHider();
      }
    }
  }

  findNestedRow(target) {
    const elements = [];
    let nextSibling = target.nextElementSibling;
    while (nextSibling) {
      if (nextSibling.classList.contains("skip")) {
        elements.push(nextSibling);
        nextSibling = nextSibling.nextElementSibling;
      } else {
        nextSibling = false;
      }
    }
    return elements;
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

  afterSubmitRefresh(event) {
    const [xhr, status] = event.detail;
    if (status == "OK" || status == "Created") {
      const success = JSON.parse(xhr.response);
      Swal.fire({
        title: "Sukses",
        text: success.resText,
        icon: "success",
        confirmButtonText: "Ok",
      }).then(() => {
        Turbolinks.visit(window.location, { action: "replace" });
      });
    } else {
      const errors = JSON.parse(xhr.response);
      this.errorContainerTargets.forEach((errorContainer) => {
        const errorType = errorContainer.dataset.errorType;
        if (errors.hasOwnProperty(errorType)) {
          errorContainer.previousElementSibling.classList.add("is-invalid");
          errorContainer.innerHTML = errors[errorType];
          errorContainer.style.display = "inline";
        } else {
          errorContainer.style.display = "none";
        }
      });
      this.sweetalertStatus(errors.resText, "error");
    }
  }

  successResponseRefresh(event) {
    // event.preventDefault()
    const [message, status, xhr] = event.detail;
    const modal_target = event.params.modal;
    const modal = document.getElementById(modal_target);
    // event after successResponse
    Modal.getInstance(modal).hide();
    if (status == "OK" || status == "Created") {
      Swal.fire({
        title: "Sukses",
        text: status,
        icon: "success",
        confirmButtonText: "Ok",
      }).then(() => {
        Turbolinks.visit(window.location, { action: "replace" });
      });
    } else {
      this.sweetalertStatus("terjadi kesalahan", "error");
    }
  }

  successResponse(event) {
    // event.preventDefault()
    const [message, status, xhr] = event.detail;
    const modal_target = event.params.modal;
    const modal = document.getElementById(modal_target);
    const ajax_update_event = new CustomEvent("ajax-update", {
      detail: { data: message.result },
    });
    // event after successResponse
    Modal.getInstance(modal).hide();
    super.sweetalert(message.resText);
    window.dispatchEvent(ajax_update_event);
  }

  successResponseNew(event) {
    // event.preventDefault()
    const [message, status, xhr] = event.detail;
    const modal = event.params.modal;
    const target = document.getElementById(event.params.pohon);
    const { resText, html_content } = JSON.parse(message.response);

    super.modalHider(modal);
    target.innerHTML = html_content;
    this.sweetalertStatus(resText, status);
  }

  successWithFixNow(event) {
    const [message, status] = event.detail;
    const modal = event.params.modal;
    const target = document.getElementById(event.params.pohon);
    const resText = message.resText;
    const html_content = message.html_content;

    super.modalHider(modal);
    target.innerHTML = html_content;
    this.sweetalertStatus(resText, status);
  }

  successResponseTransferPohon(event) {
    // event.preventDefault()
    const [message, status, xhr] = event.detail;
    this.sweetalertStatus(message.resText, status);
    const target_element = this.buttonTarget;
    target_element.innerHTML = message.result;
  }

  successResponseStrategiPohon(event) {
    // event.preventDefault()
    const [message, status, xhr] = event.detail;
    const modal = event.params.modal;
    const id_strategi = `strategi_pohon_${message.result}`;
    const target_element = document.getElementById(id_strategi);
    const url = `/strategis/${message.result}`;
    // event after successResponse
    super.modalHider(modal);
    fetch(url, {
      method: "get",
    })
      .then((response) => response.text())
      .then((text) => {
        this.sweetalertStatus(message.resText, status);
        target_element.innerHTML = text;
      })
      .catch((e) => {
        this.sweetalertStatus("terjadi kesalahan", "error");
      });
  }

  successResponseSpbe(event) {
    // event.preventDefault()
    const [message, status, xhr] = event.detail;
    const modal_target = event.params.modal;
    const modal = document.getElementById(modal_target);
    const ajax_update_event = new CustomEvent("sasaran-new", {
      detail: { data: message },
    });
    // event after successResponse
    Modal.getInstance(modal).hide();
    super.sweetalert(message.resText);
    document.dispatchEvent(ajax_update_event);
  }

  successResponseBagikan(event) {
    // event.preventDefault()
    const [message, status, xhr] = event.detail;
    const modal_target = event.params.modal;
    const modal = document.getElementById(modal_target);
    const ajax_update_event = new CustomEvent("ajax-update", {
      detail: { data: message.result },
    });
    // event after successResponse
    Modal.getInstance(modal).hide();
    this.sweetalertStatus(message.resText, status);
    window.dispatchEvent(ajax_update_event);
  }

  successResponseRenderNew(event) {
    // event.preventDefault()
    const [message, status, xhr] = event.detail;
    const modal_target = event.params.modal;
    const modal = document.getElementById(modal_target);
    const ajax_update_event = new CustomEvent("ajax-update", {
      detail: { data: message.result },
    });
    // event after successResponse
    Modal.getInstance(modal).hide();
    const { roles, target } = message.result;
    const target_row = document.getElementById(target);
    target_row.innerHTML = `<ul>${roles
      .map((n) => `<li>${n}</li>`)
      .join("")}</ul>`;
    target_row.style.backgroundColor = "lime";
  }

  successWithoutModal(event) {
    const [message, status, xhr] = event.detail;
    // event after successResponse
    super.sweetalert(message.resText);
  }

  errorWithoutModal(event) {
    const [message, status] = event.detail;
    const errors = message.errors;
    this.errorContainerTargets.forEach((errorContainer) => {
      const errorType = errorContainer.dataset.errorType;
      const errorMsg = extractError({ errors, type: errorType });
      if (errorMsg === undefined) {
        errorContainer.style.display = "none";
      } else {
        errorContainer.previousElementSibling.classList.add("is-invalid");
        errorContainer.innerHTML = errorMsg;
        errorContainer.style.display = "inline";
      }
    });
  }

  responseAfter(event) {
    // event.preventDefault()
    const [message, status, xhr] = event.detail;
    const modal = event.parentElement.parentElement.parentElement.parentElement;
    this.sweetalertStatus(message.resText, status);
    // event after successResponse
    Modal.getInstance(modal).hide();
  }

  afterClone(event) {
    const [message, status, _xhr] = event.detail;
    super.modalHider();
    const text = JSON.parse(message.response);
    this.sweetalertStatus(text.resText, status);
  }

  afterClonePokin(event) {
    const [message, status, _xhr] = event.detail;
    super.modalHider();
    const { resText, html_content } = JSON.parse(message.response);
    this.sweetalertStatus(resText, status);

    if (this.hasElementIdValue) {
      const target = document.getElementById(this.elementIdValue);
      target.insertAdjacentHTML("beforeend", html_content);
    }
  }

  sweetalert(text) {
    Swal.fire({
      title: "Sukses",
      text: text,
      icon: "success",
      confirmButtonText: "Ok",
    });
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

function extractError({ errors, type }) {
  if (!errors || !Array.isArray(errors)) return;
  const foundError = errors.find(
    (error) => error.id.toLowerCase() === type.toLowerCase(),
  );
  return foundError?.title;
}
