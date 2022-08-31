import { Controller } from 'stimulus'
import { Modal } from 'bootstrap'
import Swal from "sweetalert2";


export default class extends Controller {
  successResponse(event) {
    // event.preventDefault()
    const [message, status, xhr] = event.detail
    const modal = document.getElementById('form-isu-strategis')
    const ajax_update_event = new CustomEvent("ajax-update", { detail: { data: message  } })
    // event after successResponse
    Modal.getInstance(modal).hide()
    this.sweetalert()
    window.dispatchEvent(ajax_update_event)
  }

  sweetalert() {
    Swal.fire({
      title: 'Sukses',
      text: "Isu Strategis ditambahkan",
      icon: "success",
      confirmButtonText: 'Ok',
    })
  }
}
