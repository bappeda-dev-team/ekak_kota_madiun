import { Controller } from 'stimulus'

//need sweet alert import

export default class extends Controller {
  static targets = ['isu_strategis', 'prevHtml', 'formRemote']

  static values = {
    target: String
  }

  updateTargetValue(event) {
    const content = event.detail
    this.isu_strategisTarget.innerHTML = content.data
  }

  appendForm(event) {
    const target = event.currentTarget
    let location = event.params.location
    let result_target = event.params.target
    this.formFetcher(target.href, location)
  }

  remoteForm(e) {
    const [xhr, status] = e.detail
    const target = this.formRemoteTarget
    const prevHtml = this.prevHtmlTarget
    prevHtml.classList.add('d-none')

    if (status == 'OK') {
      const html = xhr.response
      target.insertAdjacentHTML('beforeend', html)
    }
    else {
      // const html = this.errorHtml()
      const html = xhr.response
      target.insertAdjacentHTML('beforeend', html)
    }
  }

  formFetcher(url, target) {
    fetch(url)
      .then((res) => res.text())
      .then((html) => {
        document.getElementById(target).innerHTML = html
      });
  }

  success(event) {
    const [xhr, status] = event.detail
    const target = 'form-modal-body'
    const element = document.getElementById(target)

    console.log(status)

    if (status == 'OK') {
      const html = xhr.response
      element.innerHTML = html
    }
    else {
      const html = '<div class="alert alert-danger" role="alert">Terjadi Kesalahan</div>'
      element.innerHTML = html
    }
  }

  errorHtml() {
    return `
        <div class="alert alert-danger" role="alert">
          Terjadi Kesalahan
          <br>
          Klik Batal untuk menutup
        </div>
        `
  }
}
