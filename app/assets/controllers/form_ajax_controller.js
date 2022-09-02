import { Controller } from 'stimulus'
import { Modal } from 'bootstrap'
import Swal from "sweetalert2";


export default class extends Controller {
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

  sweetalert(text) {
    Swal.fire({
      title: 'Sukses',
      text: text,
      icon: "success",
      confirmButtonText: 'Ok',
    })
  }
}
