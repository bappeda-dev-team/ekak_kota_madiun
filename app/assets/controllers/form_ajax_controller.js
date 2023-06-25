import { Controller } from 'stimulus'
import { Modal } from 'bootstrap'
import Swal from "sweetalert2";


export default class extends Controller {
  static targets = ["errorContainer"]
  successResponse(event) {
    // event.preventDefault()
    const [message, status, xhr] = event.detail
    const modal_target = event.params.modal
    const modal = document.getElementById(modal_target)
    const ajax_update_event = new CustomEvent("ajax-update", { detail: { data: message.result  } })
    // event after successResponse
    Modal.getInstance(modal).hide()
    this.sweetalert(message.resText)
    window.dispatchEvent(ajax_update_event)
  }

  successResponseNew(event) {
    // event.preventDefault()
    const [message, status, xhr] = event.detail
    const modal_target = event.params.modal
    const modal = document.getElementById(modal_target)
    const id_strategi = `strategi_pohon_${message.result}`
    const target_element = document.getElementById(id_strategi)
    const url = `/pohon_kinerja/${message.result}/daftar_temans`
    // event after successResponse
    Modal.getInstance(modal).hide()
    fetch(url,
            {
                    method: "get"
            })
            .then(
                    response => response.text()

            )
            .then(
                    text => {
                      this.sweetalertStatus(message.resText, status)
                      target_element.innerHTML = text
                    }
            ).catch(
                    e => {
                      this.sweetalertStatus('terjadi kesalahan', 'error')
                    }

            )

  }

  successResponseSpbe(event) {
    // event.preventDefault()
    const [message, status, xhr] = event.detail
    const modal_target = event.params.modal
    const modal = document.getElementById(modal_target)
    const ajax_update_event = new CustomEvent("sasaran-new", { detail: { data: message  } })
    // event after successResponse
    Modal.getInstance(modal).hide()
    this.sweetalert(message.resText)
    document.dispatchEvent(ajax_update_event)
  }

  successResponseBagikan(event) {
    // event.preventDefault()
    const [message, status, xhr] = event.detail
    const modal_target = event.params.modal 
    const modal = document.getElementById(modal_target)
    const ajax_update_event = new CustomEvent("ajax-update", { detail: { data: message.result  } })
    // event after successResponse
    Modal.getInstance(modal).hide()
    this.sweetalertStatus(message.resText, status)
    window.dispatchEvent(ajax_update_event)
  }

  successResponseRenderNew(event) {
    // event.preventDefault()
    const [message, status, xhr] = event.detail
    const modal_target = event.params.modal 
    const modal = document.getElementById(modal_target)
    const ajax_update_event = new CustomEvent("ajax-update", { detail: { data: message.result  } })
    // event after successResponse
    Modal.getInstance(modal).hide()
    this.sweetalert(message.resText)
    const {roles, target} = message.result
    const target_row = document.getElementById(target)
    target_row.innerHTML = `<ul>${roles.map( n => `<li>${n}</li>`).join('')}</ul>`
    target_row.style.backgroundColor = 'lime'
  }

  successWithoutModal(event) {
    const [message, status, xhr] = event.detail
    // event after successResponse
    this.sweetalert(message.resText)
  }

  errorWithoutModal(event) {
    const [message, status] = event.detail
    const errors = message.errors
    this.errorContainerTargets.forEach((errorContainer) => {
      const errorType = errorContainer.dataset.errorType
      const errorMsg = extractError({ errors, type: errorType }) 
      if(errorMsg === undefined)
      {
        errorContainer.style.display = 'none'
      }
      else {
        errorContainer.previousElementSibling.classList.add('is-invalid')
        errorContainer.innerHTML = errorMsg
        errorContainer.style.display = 'inline'
      }
    })
  }

  sweetalert(text) {
    Swal.fire({
      title: 'Sukses',
      text: text,
      icon: "success",
      confirmButtonText: 'Ok',
    })
  }

  sweetalertStatus(text, status) {
    console.log(status)
    if(status == 'Accepted')
      {
    Swal.fire({
      title: 'Sukses',
      text: text,
      icon: "success",
      confirmButtonText: 'Ok',
    })
      }
    else if(status == 'OK') {
    Swal.fire({
      title: 'Tidak ada perubahan',
      text: text,
      icon: "info",
      confirmButtonText: 'Ok',
    })
    }
    else {
    Swal.fire({
      title: 'Gagal',
      text: text,
      icon: "error",
      confirmButtonText: 'Ok',
    })
      }
  }
}

function extractError({ errors, type }) {
  if (!errors || !Array.isArray(errors)) return
    const foundError = errors.find(
          (error) => error.id.toLowerCase() === type.toLowerCase()
        )
    return foundError?.title
}
