import { Controller } from 'stimulus'
import { Modal } from 'bootstrap'
import Swal from "sweetalert2";
import Turbolinks from "turbolinks";

export default class extends Controller {
  static targets = ["dahan", "tematik"]
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
      const html = this.errorHtml()
      target.insertAdjacentHTML('beforeend', html)
    }
  }

  pindahPohon(e) {
    const [xhr, status] = e.detail
    const target = e.target.closest('.tf-nc')
    const prevHtml = target.querySelector('.pohon')
    prevHtml.classList.add('d-none')

    if (status == 'OK') {
      const html = xhr.response
      target.insertAdjacentHTML('beforeend', html)
    }
    else {
      const html = this.errorHtml()
      target.insertAdjacentHTML('beforeend', html)
    }
  }

  pindahSuccess(e) {
    const [xhr] = e.detail
    this.sweetAlertSuccess(xhr.resText)
    setTimeout(() => {
      Turbolinks.visit(window.location, { action: "replace" })
    }, 700)

  }

  closeInlineForm(e) {
    const target = e.target.closest('.tf-nc')
    const prevHtml = target.querySelector('.pohon')
    prevHtml.classList.remove('d-none')
    const element = target.querySelector('.pohon-form')
    element.remove()
  }


  addSubTematik(e) {
    const [xhr, status] = e.detail
    const target = document.getElementById(e.params.id)

    if (status == 'OK') {
      const html = xhr.response
      target.insertAdjacentHTML('beforeend', html)
    }
    else {
      const html = this.errorHtml()
      target.insertAdjacentHTML('beforeend', html)
    }
  }

  addOpdTematik(e) {
    const [xhr, status] = e.detail
    const target = document.getElementById(e.params.id)

    if (status == 'OK') {
      const html = xhr.response
      target.insertAdjacentHTML('beforeend', html)
    }
    else {
      const html = this.errorHtml()
      target.insertAdjacentHTML('beforeend', html)
    }
  }

  addStrategiTematik(e) {
    const [xhr, status] = e.detail
    const parent = e.currentTarget.closest('li')
    const target = parent.querySelector('ul')

    if (status == 'OK') {
      const html = xhr.response
      target.insertAdjacentHTML('beforeend', html)
    }
    else {
      const html = this.errorHtml()
      target.insertAdjacentHTML('beforeend', html)
    }
  }

  errorHtml() {
    return `
    <li>
      <div class="tf-nc" style="width: 450px;">
        <div class="pohon-title">
          <h5 class="text-center"><strong>Error</strong></h5>
        </div>
        <div class="pohon-body">
          <div class="alert alert-danger" role="alert">
            Terjadi Kesalahan
            <br>
            Klik Batal untuk menutup
          </div>
        </div>
        <div class="pohon-foot">
          <button type="button" class="btn btn-danger w-100" aria-label="Close" data-action="pohon-tematik#closeForm">Batal</button>
        </div>
      </div>
    </li>`
  }

  closeForm(e) {
    const element = e.target.closest('li')
    element.remove()
  }

  ajaxSuccess(e) {
    const [xhr] = e.detail
    this.sweetAlertSuccess(xhr.resText)
    const target = e.currentTarget.closest('li')
    const html = xhr.attachmentPartial
    target.innerHTML = html
  }

  updateSuccess(e) {
    const [xhr] = e.detail
    this.sweetAlertSuccess(xhr.resText)
    const target = e.currentTarget.closest('.tf-nc')
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
