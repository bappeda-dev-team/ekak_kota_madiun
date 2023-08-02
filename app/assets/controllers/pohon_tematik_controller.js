import { Controller } from 'stimulus'
import { Modal } from 'bootstrap'
import Swal from "sweetalert2";
// import Turbolinks from "turbolinks";

export default class extends Controller {
  static targets = ["dahan"]
  static values = {
    elementId: String
  }

  addPohon(e) {
    const [xhr, status] = e.detail
    const target = this.dahanTarget

    if (status == 'OK') {
      const html = xhr.response
      target.insertAdjacentHTML('beforeend', html)
    }
    else {
      const html = '<div class="alert alert-danger" role="alert">Terjadi Kesalahan</div>'
      target.insertAdjacentHTML('beforeend', html)
    }
  }

  ajaxSuccess(e) {
    const [xhr] = e.detail
    this.sweetAlertSuccess(xhr.resText)
    const target = e.currentTarget.parentElement.parentElement.parentElement
    const html = xhr.attachmentPartial
    target.innerHTML = html
  }

  ajaxError(e) {
    const [xhr] = e.detail
    this.sweetAlertFailed(xhr.resText)
    this.partialAttacher('form-modal-body', xhr.errors)
  }

  partialAttacher(targetName, html_element) {
    const target = document.getElementById(targetName)
    target.innerHTML = html_element
  }

  // modalName is standardize in layout/application.html.erb
  modalHider(modalName = 'form-modal') {
    const modal = document.getElementById(modalName)
    Modal.getInstance(modal).hide()
  }

  sweetAlertSuccess(text) {
    Swal.fire({
      title: 'Sukses',
      text: text,
      icon: "success",
      confirmButtonText: 'Ok',
    })
  }

  sweetAlertFailed(text) {
    Swal.fire({
      title: 'Gagal',
      text: text,
      icon: "error",
      confirmButtonText: 'Ok',
    })
  }
}
