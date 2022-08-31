import { Controller } from 'stimulus'
import { Modal } from 'bootstrap'
import Swal from "sweetalert2";


export default class extends Controller {
  successResponse(event) {
    // event.preventDefault()
    const [message, status, xhr] = event.detail
    const modal = document.getElementById('form-isu-strategis')    
    const [pesan,target] = message 
    // event after successResponse
    Modal.getInstance(modal).hide()
    this.sweetalert()
    this.updateTargetValue(target,pesan)
  }

  updateTargetValue(target, message) {
    document.getElementById(target).innerHTML = message
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
