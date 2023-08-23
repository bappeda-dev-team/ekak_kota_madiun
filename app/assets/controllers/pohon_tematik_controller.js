import { Controller } from 'stimulus'
import { Modal } from 'bootstrap'
import Swal from "sweetalert2";
import Turbolinks from "turbolinks";
import $ from 'jquery'

export default class extends Controller {
  static targets = ["dahan", "tematik", "dropdown", "strategi"]
  static values = {
    elementId: String,
    display: Boolean
  }

  get select() {
    return $(this.element);
  }

  get default_options() {
    let options = {
      width: "100%",
      theme: "bootstrap-5",
      // dropdownParent: this.parentValue
    }
    return options
  }

  dropdownTargetConnected(el) {
    const select = $(el).select2(this.default_options)
    select.on('select2:open', () => {
      document.querySelector('.select2-search__field').focus()
    })
    select.on('select2:select', () => {
      const event = new CustomEvent('change', { bubbles: true, detail: { opd_id: this.dropdownTarget.value } })
      el.dispatchEvent(event)
    })
  }

  strategiTargetConnected(el) {
    const select = $(el).select2(this.default_options)
    select.on('select2:open', () => {
      document.querySelector('.select2-search__field').focus()
    })
  }

  updateStrategi(e) {
    const opd_id = e.detail.opd_id
    const target = $(this.strategiTarget)

    const defaultMatcher = $.fn.select2.defaults.defaults.matcher;

    function opd_matcher(opdId) {
      return opdId == opd_id
    }

    target.select2({
      width: "100%",
      theme: "bootstrap-5",
      matcher: function (params, data) {
        if ($.trim(params.term) === '') {
          if (opd_matcher(data.element.dataset.opdId)) {
            return data;
          }
        }
        // Do not display the item if there is no 'text' property
        if (typeof data.text === 'undefined') {
          return null;
        }
        // Check if the data occurs
        if (params.term) {
          if (opd_matcher(data.element.dataset.opdId)) {
            return defaultMatcher(params, data)
          }
        }

        return null;
      }
    })
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

  toggleChild(e) {
    const button = e.target
    const child = button.closest('li').querySelector('ul')
    const display = !e.params.show
    this.showChild(display, button)
    child.classList.toggle('d-none')
    button.dataset.pohonTematikShowParam = display
  }

  showChild(display, button) {
    if (display) {
      button.classList.remove('btn-tertiary')
      button.classList.add('btn-danger')
      button.innerText = 'Sembunyikan'
    }
    else {
      button.classList.remove('btn-danger')
      button.classList.add('btn-tertiary')
      button.innerText = 'Tampilkan'
    }
  }

  ajaxSuccess(e) {
    const [xhr] = e.detail
    this.sweetAlertSuccess(xhr.resText)
    const target = e.currentTarget.closest('li')
    const html = xhr.attachmentPartial
    target.innerHTML = html
  }

  ajaxDelete(e) {
    const [xhr] = e.detail
    this.sweetAlertSuccess(xhr.resText)
    const target = e.target.closest('li')
    target.remove()
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
