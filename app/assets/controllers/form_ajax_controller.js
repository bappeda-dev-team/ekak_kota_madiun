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
}

function extractError({ errors, type }) {
  if (!errors || !Array.isArray(errors)) return
    const foundError = errors.find(
          (error) => error.id.toLowerCase() === type.toLowerCase()
        )
    return foundError?.title
}
